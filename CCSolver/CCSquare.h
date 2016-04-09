//
//  CCSquare.h
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 28/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCSquare : NSObject

+(instancetype)initWithIndex:(NSUInteger)index row:(int)row column:(int)column;

// The code index, i.e. the numbers in the squares of the puzzle (1-26)
@property NSUInteger codeIndex;
// The square value, i.e. the letter written in the square as the answer (a-z)
@property char character;
// The position of the square in the puzzle array
@property NSUInteger row;
@property NSUInteger column;

-(char)character;
-(void)setCharacter:(char)character;
-(BOOL)containsCharacter;
-(void)print;
-(NSString *)valueAsString;

@end
