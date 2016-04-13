//
//  CCWord.m
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 30/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import "CCWord.h"
#import "CCWordSolver.h"

@implementation CCWord

-(id)init {
    if (self = [super init]) {
        self.squares = [NSMutableArray array];
        self.solutions = [NSArray array];
        self.validatedAtMoveNumber = -1;
        return self;
    } else
        return nil;
}

+(instancetype)word {
    CCWord *instance = [[[self class] alloc] init];
    return instance;
}

+(instancetype)wordWithSquare:(CCSquare *)square {
    CCWord *instance = [CCWord word];
    [instance.squares addObject:square];
    return instance;
}

+(instancetype)wordWithSquares:(NSArray *)squares {
    CCWord *instance = [CCWord word];
    [instance.squares addObjectsFromArray:squares];
    return instance;
}

#pragma mark Calculated properties

-(NSUInteger)length {
    return [_squares count];
}

-(WordDirection)direction {
    
    // If the word is only one letter it can not have a direction
    if ([self length] < 2) {
        return Unknown;
    } else {
        // Calculate the direction of the word based on the first two square positions
        CCSquare *first = _squares[0];
        CCSquare *second = _squares[1];
        WordDirection direction;
        if (first.row == second.row) {
            direction = Across;
            return direction;
        } else if (first.column == second.column) {
            direction = Down;
            return direction;
        } else {
            return Unknown;
        }
    }
}

// The difficulty of a word is calculated by assessing the degree of unknowns
// difficulty = [number of unknown letters] - [number of letter patterns]
//
-(NSUInteger)difficulty {
    
    NSUInteger difficulty = 0;
    
    // Get the solving criteria
    NSDictionary *allCriteria = [CCWordSolver criteriaForWord:self];
    NSArray *criteriaKeys = allCriteria.allKeys;

    // Formatter for checking if criteria dictionary keys are letters or numbers
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    for (NSString *key in criteriaKeys) {
        // Try to convert the key to a code cracker integer index
        NSNumber *decimalKey = [formatter numberFromString:key];
        
        if (decimalKey != nil) {
            // Key is for an unknown character.
            NSDictionary *criteria = allCriteria[key];
            NSUInteger count = [criteria count];
            // + Number of unknown characters
            difficulty += count;
            // -1 If there is a character pattern
            if (count > 1) {
                difficulty--;
            }
        }
    }
    
    return difficulty;
}

-(NSUInteger)numberOfUnknownLetters {
    NSMutableArray *unknowns = [[NSMutableArray alloc] init];
    
    for (CCSquare *square in _squares) {
        if (![square containsCharacter]) {
            NSNumber *index = [[NSNumber alloc] initWithUnsignedLong:square.codeIndex];
            if (![unknowns containsObject:index]) {
                [unknowns addObject:index];
            }
        }
    } 
    return [unknowns count];
}

// Returns the word as a string or nil if the word is incomplete
-(NSString *)stringValue {
    if ([self numberOfUnknownLetters] != 0) {
        return nil;
    } else {
        NSMutableString *word = [[NSMutableString alloc] init];
        for (CCSquare *square in _squares) {
            [word appendString:[square valueAsString]];
        }
        return [NSString stringWithString:word];
    }
}


#pragma mark NSCopying Protocol

-(id)copyWithZone:(NSZone *)zone
{
    NSMutableArray *squares = [[NSMutableArray alloc] initWithCapacity:[_squares count]];
    for (CCSquare *square in _squares) {
        [squares addObject:[square copy]];
    }
    CCWord *another = [CCWord wordWithSquares:squares];
    another.solutions = [_solutions copy];
    return another;
}

#pragma mark Instance methods

// Appends a square to the word
//
-(void)addSquare:(CCSquare *)square {
    [_squares addObject:square];
}

// Executes a block for all squares in a word
//
-(void)forAllSquares:(void (^)(CCSquare*))block {
    for (CCSquare* square in _squares) {
        block(square);
    }
}

// Finds possible solutions for the words and saves them as an array to the solutions property
-(void)updateSolutions {
    _solutions = [CCWordSolver shortlistForIncompleteWord:self];
}

// Returns the number of solutions currently stored in the solutions property
//
-(NSUInteger)numberOfSolutions {
    return [_solutions count];
}

// Prints details about the word to the console
//
-(void)print {
    CCSquare *first = _squares[0];
    printf("(%lu, %lu) ", (unsigned long)first.row, (unsigned long)first.column);
    switch (self.direction) {
        case Across: {
            printf("Across: ");
            break;
        }
        case Down: {
            printf("Down: ");
            break;
        }
        default: {
            printf("Unknown: ");
        }
    }
    NSMutableString *word = [[NSMutableString alloc] init];
    for (CCSquare *square in _squares) {
        if (![square containsCharacter]) {
            [word appendString:@"*"];
        } else {
            [word appendString:[square valueAsString]];
        };
    }
    [word appendString:[NSString stringWithFormat:@" (difficulty: %lu, solutions: %lu)\n", (unsigned long)self.difficulty, (unsigned long)[self numberOfSolutions]]];
    printf("%s", [word UTF8String]);
}

@end
