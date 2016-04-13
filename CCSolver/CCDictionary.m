//
//  CCDictionary.m
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 7/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import "CCDictionary.h"
#import <UIKit/UIKit.h>

@implementation CCDictionary

+(NSArray *)englishDictionary {
    
    // Load the dictionary
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString* filePath = [bundle pathForResource:@"EnglishDictionary" ofType:@"txt"];
    NSData *dictFileData = [NSData dataWithContentsOfFile:filePath];
    NSString *dictFileContents = [[NSString alloc] initWithData:dictFileData encoding:NSUTF8StringEncoding];
    NSMutableArray<NSString *> *words = [[dictFileContents componentsSeparatedByCharactersInSet: [NSMutableCharacterSet newlineCharacterSet]] mutableCopy];
    
    // Remove entries with no characters
    for (NSInteger i = [words count] - 1; i >= 0; i--) {
        if ([words[i] length] == 0) {
            [words removeObjectAtIndex:i];
        }
    }
    
    NSArray<NSString *> *dict = [words copy];
    return dict;
}

+(BOOL)isInEnglishDictionary:(NSString *)word {
    
    NSString* lowerCaseWord = [word lowercaseString];
    
    NSArray<NSString *> *dictionary = [CCDictionary englishDictionary];
    for (NSString *dictWord in dictionary) {
        if ([dictWord isEqualToString:lowerCaseWord]) {
            NSLog(@"Word verified in dictionary: %@", word);
            return true;
        }
    }
    return false;
}

@end
