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

// Loads the dictionary txt file as an array of words
//
+(NSArray *)englishDictionary {
    
    // Load the dictionary
    NSData *dictFileData = [[NSDataAsset alloc] initWithName:@"EnglishDictionary"].data;
    NSString *dictFileContents = [[NSString alloc] initWithData:dictFileData encoding:NSUTF8StringEncoding];
    NSMutableArray *words = [[dictFileContents componentsSeparatedByCharactersInSet: [NSMutableCharacterSet newlineCharacterSet]] mutableCopy];
    
    // Remove entries with no characters
    for (NSInteger i = [words count] - 1; i >= 0; i--) {
        
        if ([words[i] length] == 0) {
            [words removeObjectAtIndex:i];
        }
    }
    
    NSArray *dict = [words copy];
    return dict;
}

// Returns true is the given word is in the dictionary
//
+(BOOL)isInEnglishDictionary:(NSString *)word {
    
    NSString* lowerCaseWord = [word lowercaseString];
    
    NSArray *dictionary = [CCDictionary englishDictionary];
    for (NSString *dictWord in dictionary) {
        if ([dictWord isEqualToString:lowerCaseWord]) {
            NSLog(@"Word verified in dictionary: %@", word);
            return true;
        }
    }
    return false;
}

@end
