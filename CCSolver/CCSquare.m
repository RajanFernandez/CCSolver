//
//  CCSquare.m
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 28/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import "CCSquare.h"

@implementation CCSquare

@synthesize character = _character;

-(id)init {
    if (self = [super init]) {
        self.codeIndex = 0;
        self.character = '\0';
        self.row = 0;
        self.column = 0;
        return self;
    } else
        return nil;
}

+(instancetype)square {
    CCSquare *square = [[[self class] alloc] init];
    return square;
}

+(instancetype)squareWithIndex:(NSUInteger)index row:(int)row column:(int)column {
    CCSquare *square = [CCSquare square];
    square.codeIndex = index;
    square.row = row;
    square.column = column;
    return square;
}

+(instancetype)squareWithIndex:(NSUInteger)index character:(char)character row:(int)row column:(int)column {
    CCSquare *square = [CCSquare square];
    square.codeIndex = index;
    square.character = character;
    square.row = row;
    square.column = column;
    return square;
}

-(id)copyWithZone:(NSZone *)zone
{
    CCSquare *another = [[[self class] alloc] init];
    another.codeIndex = _codeIndex;
    another.character = _character;
    another.row = _row;
    another.column = _column;
    return another;
}

-(char)character {
    return _character;
}

-(void)setCharacter:(char)character {
    
    // Check that the character is a letter of the alphabet and if it isn't set charcter to nil.
    NSCharacterSet *alphabet = [NSCharacterSet letterCharacterSet];
    if (![alphabet characterIsMember:character]) {
        _character = '\0';
        return;
    }
    
    // Capitalise stored characters
    NSString *upperCase = [[NSString stringWithFormat:@"%c", character] uppercaseString];
    _character = [upperCase characterAtIndex:0];
}

-(BOOL)containsCharacter {
    return self.character != '\0';
}

-(void)print {
    printf("index: %lu, value: %c, row: %lu, column %lu.\n", (unsigned long)_codeIndex, self.character, (unsigned long)_row, (unsigned long)_column);
}

-(NSString *)valueAsString {
    return [NSString stringWithFormat:@"%c", self.character];
}

@end
