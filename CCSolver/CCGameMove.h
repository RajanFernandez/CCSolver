//
//  CCGameMove.h
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 7/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCWord.h"

@interface CCGameMove : NSObject

@property NSArray *options;
@property NSUInteger optionIndex;
@property (readonly) NSString* solution;
@property CCWord *unsolvedWord;

+(instancetype)initWithOptions:(NSArray *)options andOptionIndex:(NSUInteger)index forWord:(CCWord *)word;

-(NSString *)solution;
-(char)characterForIndex:(NSUInteger)index;
-(BOOL)isOnLastOption;
-(void)goToNextOption;

@end
