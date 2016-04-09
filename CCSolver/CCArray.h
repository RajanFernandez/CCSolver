//
//  CCArray.h
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 28/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSquare.h"
#import "CCWord.h"

@interface CCArray : NSObject

@property NSArray *array;
@property NSArray *words;

+(instancetype)initWithArray:(NSArray *)array;
+(NSArray *)wordsInArray:(CCArray *)array;

// Array and square properties
-(NSUInteger)numberOfRows;
-(NSUInteger)numberOfColumns;
-(BOOL)characterAtRow:(NSUInteger)row column:(NSUInteger)column;
-(NSUInteger)numberOfAcrossWords;
-(NSUInteger)numberOfDownWords;

// Finding words
-(BOOL)acrossWordDoesStartAtSquare:(CCSquare *)square;
-(CCWord *)acrossWordStartingAtSquare:(CCSquare *)square;
-(BOOL)downWordDoesStartAtSquare:(CCSquare *)square;
-(CCWord *)downWordStartingAtSquare:(CCSquare *)square;

// Code index and character getters / setters
-(NSUInteger)codeIndexAtRow:(NSUInteger)row Column:(NSUInteger)column;
-(char)characterAtRow:(NSUInteger)row Column:(NSUInteger)column;
-(void)setCharacter:(char)character ForRow:(NSUInteger)row Column:(NSUInteger)column;

// Other utility methods
-(CCSquare *)squareAtRow:(NSUInteger)row coluum:(NSUInteger)column;
-(void)forAllSquaresInArray:(void (^)(CCSquare*))block;
-(void)print;

@end
