//
//  CCGame.m
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 30/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import "CCGame.h"
#import "CCDictionary.h"

#define LETTERS_IN_ALPHABET 26

@implementation CCGame

+(instancetype)initWithArray:(NSArray*)array {
    CCGame *instance = [[[self class] alloc] init];
    instance.array = [CCArray arrayWithArray:array];
    instance.code = [[NSMutableArray alloc] initWithCapacity:LETTERS_IN_ALPHABET];
    for (int i = 0; i < LETTERS_IN_ALPHABET; i++) {
        [instance.code insertObject:[NSNull null] atIndex:i];
    }
    instance.words = [CCArray wordsInArray:instance.array];
    instance.history = [[NSMutableArray alloc] init];
    instance.verifiedWords = [[NSMutableArray alloc] init];
    return instance;
}

// Returns zero if the puzzle was solved ok
//
-(int)solve {
    
    // Record start time
    NSDate *start = [[NSDate alloc] init];
    
    // Get the number of words that need to be solved
    int unsolvedWords = [self numberOfUnsolvedWords];
    
    while (unsolvedWords > 0) {
        NSLog(@"Solving with %d unsolved words", unsolvedWords);
        
        // Find the words that are the easiest to solve (based on their difficulty ratings)
        CCWord *nextEasiestWord = [self nextEasiestWord];
        
        // If there are no possible solutions undo the last move and try again
        if ([nextEasiestWord.solutions count] == 0) {
            
            // Undo and try another option
            NSLog(@"No Options: need to undo");
            [self undoAndSetNextOption];
        
        } else {
            
            // Else make a new move
            CCGameMove *move = [self moveForWord:nextEasiestWord];
            [self addMove:move];
            
        }
        
        // Execute moves until all complete words are valid or there are no more options
        while (true) {
            
            // Try the move
            [self executeMove];
            
            if (![self completeWordsAreValid]) {
                // If some complete words are not valid undo and try the next option
                if ([self isAnotherOption]) {
                    [self undoAndSetNextOption];
                } else {
                    // Abort if there are no more options
                    NSLog(@"Out of options. Aborting");
                    return 1;
                }
            } else {
                // Break with the move is valid
                break;
            }
        }
    
        // Update the number of unsolved words
        unsolvedWords = [self numberOfUnsolvedWords];
    }
    
    NSLog(@"PUZZLE SOLVED!");
    
    NSTimeInterval elapsed = [start timeIntervalSinceNow];
    NSLog(@"Solver time: %f minutes", elapsed/60);
    
    return 0;
}

// Returns an array of unsolved words with the lowest difficulty rating.
//
-(CCWord *)nextEasiestWord {
    
    // Sort words in order of difficulty
    NSArray *wordsInOrder = [_words sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 valueForKey:@"difficulty"] > [obj2 valueForKey:@"difficulty"];
    }];
    
    // Select the words with the lowest non zero difficulty rating
    NSMutableArray *easiest = [[NSMutableArray alloc] init];
    NSUInteger lowestRating = 0;
    for (CCWord *word in wordsInOrder) {
        if (word.difficulty == 0) {
            continue;
        } else {
            if ([easiest count] == 0) {
                lowestRating = word.difficulty;
                [easiest addObject:word];
            } else if (lowestRating == word.difficulty) {
                [easiest addObject:word];
            } else {
                break;
            }
        }
    }
    
    // Return null if all the words are solved (i.e. have a difficulty rating of zero)
    if (lowestRating == 0) {
        return nil;
    }
    
    // Find solutions for the shortlist of easiest words
    [self updateSolutionsForWords:easiest];
    
    // Sort the shortlist so that the word with the least number of solutions is first
    NSArray *sortedEasiest = [easiest sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 valueForKey:@"numberOfSolutions"] > [obj2 valueForKey:@"numberOfSolutions"];
    }];
    
    // Return the least difficult word with the least possible solutions
    return sortedEasiest[0];
}

// Updates each word with possible solutions
//
-(void)updateSolutionsForWords:(NSArray *)words {
    for (CCWord *word in words) {
        [word updateSolutions];
    }
}

// Create game move for a word with the first word solution
//
-(CCGameMove *)moveForWord:(CCWord *)word {
    
    // Update the posibile solutions if neccessary
    if (word.solutions == nil) {
        [word updateSolutions];
    }
    
    // Make the move
    CCGameMove *move = [CCGameMove initWithOptions:word.solutions andOptionIndex:0 forWord:word];
    
    return move;
}

// Returns true if all complete words are valid are in the english dictionary
//
-(BOOL)completeWordsAreValid {
    
    for (CCWord *word in _words) {
        NSString *checkWord = word.stringValue;
        if (checkWord != nil && word.validatedAtMoveNumber < 0) {
            if (![self isInVerifiedWords:checkWord]) {
                // Word is not in the verified words list, so check the whole dictionary
                if (![CCDictionary isInEnglishDictionary:checkWord]) {
                    // Return false if the word is not in the dictionary
                    return false;
                }
            }
            // Mark validated words to save time on later checks
            word.validatedAtMoveNumber = [_history count] - 1;
        }
    }
    NSLog(@"Move OK.");
    return true;
}

// Checks if a word is in the local shortlist of already verified words
//
-(BOOL)isInVerifiedWords:(NSString *)word {
    
    NSString* lowerCaseWord = [word lowercaseString];
    
    for (NSString *verifiedWord in _verifiedWords) {
        if ([verifiedWord isEqualToString:lowerCaseWord]) {
            NSLog(@"Word already verified: %@", word);
            return true;
        }
    }
    return false;
}

// Marks all words in the puzzle as not validated
//
-(void)invalidateAllWordsForMoveIndex:(NSUInteger)moveIndex {
    for (CCWord *word in _words) {
        if (word.validatedAtMoveNumber >= moveIndex) {
            word.validatedAtMoveNumber = -1;
        }
    }
}

// Add the move to the game history
//
-(void)addMove:(CCGameMove *)move {
    [_history addObject:move];
}

// Executes the latest move in the game history
//
-(void)executeMove {
    
    CCGameMove *move = [_history lastObject];
    NSLog(@"Making move with word: %@", move.solution);
    
    // Update the game array
    for (int i = 0; i < move.unsolvedWord.length; i++) {
        CCSquare *square = move.unsolvedWord.squares[i];
        if (![square containsCharacter]) {
            [self setCharacter:[move characterForIndex:i] forCodeIndex:square.codeIndex];
        }
    }
}

// Undoes the most recent move
//
-(void)undoMove {
    
    NSLog(@"Undoing.");
    
    // Return if no moves have been made
    if ([_history count] == 0) {
        return ;
    }
    
    CCGameMove *move = [_history lastObject];
    NSUInteger moveIndex = [_history count] - 1;
    
    // Update the game array
    for (int i = 0; i < move.unsolvedWord.length; i++) {
        CCSquare *square = move.unsolvedWord.squares[i];
        if (![square containsCharacter]) {
            [self clearCharacterForCodeIndex:square.codeIndex];
            [self invalidateAllWordsForMoveIndex:moveIndex];
        }
    }
}

// Returns true if there is another move option availible
//
-(BOOL)isAnotherOption {
    if ([_history count] == 0) {
        return false;
    } else {
        for (CCGameMove *move in _history) {
            if (move.optionIndex < [move.options count]) {
                return true;
            }
        }
        return false;
    }
}

// Undoes moves back to the last move with more that one option, then sets that move to the next option
//
-(void)undoAndSetNextOption {
    
    NSLog(@"Going to the next option.");
    
    while ([_history count] > 0) {
        
        // Get the latest move
        CCGameMove *move = [_history lastObject];
        
        if ([move isOnLastOption]) {
            // Remove the move and get the previous that has more options
            [self undoMove];
            [_history removeObject:move];
        } else {
            [self undoMove];
            [move goToNextOption];
            return;
        }
    }
}

// Updates the with the current code index
//
-(void)updateArray {
    [_array forAllSquaresInArray:^(CCSquare* square) {
        if (square.codeIndex > 0 && square.codeIndex < 27) {
            square.character = [self characterForCodeIndex:square.codeIndex];
        }
    }];
}

// Sets a character in the code for a given index and updates the game array. NOTE: code index values are 1-26.
//
-(void)setCharacter:(char)character forCodeIndex:(NSUInteger)index {
    _code[index - 1] = [NSString stringWithFormat:@"%c", character];
    [self updateArray];
}

// Clears the character set at a given index in the code and updates the array
//
-(void)clearCharacterForCodeIndex:(NSUInteger)index {
    _code[index - 1] = [NSNull null];
    [self updateArray];
}

// Returns the character or a null character for a given code index depending on if the character for the code index is known. NOTE: code index values are 1-26.
//
-(char)characterForCodeIndex:(NSUInteger)index {
    if (_code[index - 1] != [NSNull null]) {
        NSString *character = _code[index - 1];
        return [character characterAtIndex:0];
    } else {
        return '\0';
    }
}

// Returns the number of incomplete words in the puzzle
//
-(int)numberOfUnsolvedWords {
    int count = 0;
    for (CCWord *word in _words) {
        if (word.difficulty > 0) {
            count++;
        }
    }
    return count;
}

// Prints the puzzle array to the console.
//
-(void)printArray {
    [_array print];
}

// Prints the puzzle code to the console.
//
-(void)printCode {
    for (int i = 1; i <= LETTERS_IN_ALPHABET; i++) {
        char character = [self characterForCodeIndex:i];
        printf("%2i: %c\n", i, character);
    }
}

// Prints details about the words in the puzzle to the console.
//
-(void)printWordList {
    for (CCWord *word in _words) {
        [word print];
    }
}

@end
