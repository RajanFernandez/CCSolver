//
//  CCGame.h
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 30/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCArray.h"
#import "CCWordSolver.h"
#import "CCGameMove.h"

@interface CCGame : NSObject

@property CCArray *array;
@property NSArray *words;
@property NSMutableArray *code;
@property NSMutableArray *history;
@property NSMutableArray *verifiedWords;

+(instancetype)initWithArray:(NSArray*)array;

-(int)solve;
-(void)updateSolutionsForWords:(NSArray *)words;
-(CCGameMove *)moveForWord:(CCWord *)word;
-(BOOL)completeWordsAreValid;
-(BOOL)isInVerifiedWords:(NSString *)word;
-(void)invalidateAllWordsForMoveIndex:(NSUInteger)moveIndex;
-(void)addMove:(CCGameMove *)move;
-(void)executeMove;
-(void)undoMove;
-(BOOL)isAnotherOption;
-(void)undoAndSetNextOption;
-(void)updateArray;
-(void)setCharacter:(char)character forCodeIndex:(NSUInteger)index;
-(char)characterForCodeIndex:(NSUInteger)index;
-(void)clearCharacterForCodeIndex:(NSUInteger)codeIndex;
-(int)numberOfUnsolvedWords;


// Methods for printing game features to the console
-(void)printArray;
-(void)printCode;
-(void)printWordList;

@end
