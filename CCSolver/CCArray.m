//
//  CCArray.m
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 28/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import "CCArray.h"

@implementation CCArray

// MARK: Initialisers

// Initalises the Code Cracker array with an array of the square index numbers
//
+(instancetype)initWithArray:(NSArray *)array {
    CCArray *instance = [[[self class] alloc] init];
    NSMutableArray *squares = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (int i = 0; i < [array count]; i++) {
        squares[i] = [[NSMutableArray alloc] initWithCapacity:[array[0] count]];
        for (int j = 0;  j < [array[0] count]; j++) {
            NSNumber *index = array[i][j];
            squares[i][j] = [CCSquare initWithIndex:index.unsignedIntegerValue row:i column:j];
        }
    }
    instance.array = [NSArray arrayWithArray:squares];
    instance.words = [CCArray wordsInArray:instance];
    return instance;
}

// Finds all the words in the array
//
+(NSArray *)wordsInArray:(CCArray *)array {
    NSMutableArray *words = [[NSMutableArray alloc] init];
    [array forAllSquaresInArray:^(CCSquare *square) {
        if ([array acrossWordDoesStartAtSquare:square]) {
            CCWord *word = [array acrossWordStartingAtSquare:square];
            [words addObject:word];
        }
        if ([array downWordDoesStartAtSquare:square]) {
            CCWord *word = [array downWordStartingAtSquare:square];
            [words addObject:word];
        }
    }];
    return [NSArray arrayWithArray:words];
}

// MARK: Array and square properties

-(NSUInteger)numberOfRows {
    return [self.array count];
}

-(NSUInteger)numberOfColumns {
    return [self.array[0] count];
}

// Returns true if the square is a letter square, i.e. not a black filled square
//
-(BOOL)characterAtRow:(NSUInteger)row column:(NSUInteger)column {
    CCSquare *start = _array[row][column];
    return start.codeIndex != 0;
}

-(NSUInteger)numberOfAcrossWords {
    NSUInteger count = 0;
    for (CCWord *word in _words) {
        if (word.direction == Across) {
            count++;
        }
    }
    return count;
}

-(NSUInteger)numberOfDownWords {
    NSUInteger count = 0;
    for (CCWord *word in _words) {
        if (word.direction == Down) {
            count++;
        }
    }
    return count;
}


// MARK: Finding words

// Returns true if an across word could start at the given square
//
-(BOOL)acrossWordDoesStartAtSquare:(CCSquare *)square {
    
    NSUInteger row = square.row;
    NSUInteger column = square.column;

    // If the starting square is a blank there is no word
    // Across words can not start in the last column
    if (![self characterAtRow:row column:column] || (column >= [self numberOfColumns] - 1)) {
        return false;
    }
    
    if (column == 0) {
        // If the square is in the first column and there is a letter in the second there is an across word
        return [self characterAtRow:row column:column + 1];
    } else {
        // Else if the square is the middle of the array, the square to the left must be blank for it to be the start of a word
        return (![self characterAtRow:row column:column - 1] && [self characterAtRow:row column:column + 1]);
    }
}

// Returns true if a down word could start at the given square
//
-(BOOL)downWordDoesStartAtSquare:(CCSquare *)square {
    
    NSUInteger row = square.row;
    NSUInteger column = square.column;
    
    // If the starting square is a blank there is no word
    // Across words can not start in the last column
    if (![self characterAtRow:row column:column] || (row >= [self numberOfRows] - 1)) {
        return false;
    }
    
    if (row == 0) {
        // If the square is in the first row and there is a letter in the second there is an down word
        return [self characterAtRow:row + 1 column:column];
    } else {
        // Else if the square is the middle of the array, the square above must be blank for it to be the start of a word
        return (![self characterAtRow:row - 1 column:column] && [self characterAtRow:row + 1 column:column]);
    }
}

// Returns the across word that starts at a given square
//
-(CCWord *)acrossWordStartingAtSquare:(CCSquare *)square {
    
    CCWord *word = [CCWord initWithSquare:square];
    NSUInteger row = square.row;
    NSUInteger column = square.column;
    column++;
    
    while (column < [self numberOfColumns]) {
        // Check if the next square across is a blank square
        if ([self characterAtRow:row column:column]) {
            [word addSquare:_array[row][column]];
            column++;
        } else {
            break;
        }
    }
    return word;
}

// Returns the down word that starts at a given square
//
-(CCWord *)downWordStartingAtSquare:(CCSquare *)square {
    
    CCWord *word = [CCWord initWithSquare:square];
    NSUInteger row = square.row;
    NSUInteger column = square.column;
    row++;
    
    while (row < [self numberOfRows]) {
        // Check if the next square across is a blank square
        if ([self characterAtRow:row column:column]) {
            [word addSquare:_array[row][column]];
            row++;
        } else {
            break;
        }
    }
    return word;
}


// MARK: Code index and character getters / setters

-(NSUInteger)codeIndexAtRow:(NSUInteger)row Column:(NSUInteger)column {
    CCSquare *square = _array[row][column];
    NSUInteger index = square.codeIndex;
    return index;
}

-(char)characterAtRow:(NSUInteger)row Column:(NSUInteger)column {
    CCSquare *square = _array[row][column];
    char value = square.character;
    return value;
}

-(void)setCharacter:(char)character ForRow:(NSUInteger)row Column:(NSUInteger)column{
    CCSquare *square = _array[row][column];
    square.character = character;
    return;
}


// MARK: Other utility methods

-(CCSquare *)squareAtRow:(NSUInteger)row coluum:(NSUInteger)column {
    return _array[row][column];
}

-(void)forAllSquaresInArray:(void (^)(CCSquare *))block {
    for (NSArray* row in _array) {
        for (CCSquare* square in row) {
            block(square);
        }
    }
}

-(void)print {
    for (NSArray *row in _array) {
        // Code index rows
        printf("[");
        int count = 1;
        for (CCSquare *square in row) {
            if (square.codeIndex != 0) {
                printf("%2lu   ", (unsigned long)square.codeIndex);
            } else {
                printf("#####");
            }
            if (count != row.count) {
                printf("|");
            }
            count++;
        }
        printf("]\n");
        // Character rows
        printf("[");
        count = 1;
        for (CCSquare *square in row) {
            if (square.codeIndex != 0) {
                if ([square containsCharacter]) {
                    printf("   %c ", square.character);
                } else {
                    printf("   _ ");
                }
            } else {
                printf("#####");
            }
            if (count != row.count) {
                printf("|");
            }
            count++;
        }
        printf("]\n");
    }
}

@end
