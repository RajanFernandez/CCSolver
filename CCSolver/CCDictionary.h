//
//  CCDictionary.h
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 7/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCDictionary : NSObject

+(NSArray *)englishDictionary;
+(BOOL)isInEnglishDictionary:(NSString *)word;

@end
