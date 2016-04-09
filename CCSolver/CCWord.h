//
//  CCWord.h
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 30/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordDirection.h"
#import "CCSquare.h"

@interface CCWord : NSObject

+(instancetype)initWithSquare:(CCSquare *)square;
+(instancetype)initWithSquares:(NSArray *)squares;

@property NSMutableArray *squares;
@property NSArray *solutions;
// The index of the game move where the word was validated
// < 0 : word is unvalidated, > 0 : index of move in the game history when the word was validated.
@property NSInteger validatedAtMoveNumber;
@property (readonly) NSUInteger length;
@property (readonly) WordDirection direction;
@property (readonly) NSUInteger difficulty;
@property (readonly) NSUInteger numberOfUnknownLetters;
@property (readonly) NSString *stringValue;

-(void)addSquare:(CCSquare *)square;
-(void)forAllSquares:(void (^)(CCSquare*))block;
-(void)updateSolutions;
-(NSUInteger)numberOfSolutions;
-(void)print;

@end
