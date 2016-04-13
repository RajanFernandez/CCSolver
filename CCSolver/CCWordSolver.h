//
//  CCWordSolver.h
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 30/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCWord.h"

@interface CCWordSolver : NSObject

+(NSDictionary *)criteriaForWord:(CCWord *)word;
+(NSMutableArray *)shortlistForIncompleteWord:(CCWord *)word;
+(BOOL)word:(NSString *)word hasKnownCharacter:(char)character inPlaces:(NSArray *)places;
+(BOOL)word:(NSString *)word hasCommonCharacterInPlaces:(NSArray *)places;

@end
