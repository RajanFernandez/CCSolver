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

+(instancetype)initWithIndex:(NSUInteger)index row:(int)row column:(int)column {
    CCSquare *square = [[[self class] alloc] init];
    square.codeIndex = index;
    square.character = '\0';
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
    // Capitalise stored characters
    if (character != '\0') {
        NSString *upperCase = [[NSString stringWithFormat:@"%c", character] uppercaseString];
        _character = [upperCase characterAtIndex:0];
    } else {
        _character = character;
    }
}

-(BOOL)containsCharacter {
    return self.character != '\0';
}

-(void)print {
    printf("index: %lu, value: %c, row: %lu, column %lu.\n", _codeIndex, self.character, _row, _column);
}

-(NSString *)valueAsString {
    return [NSString stringWithFormat:@"%c", self.character];
}

@end
