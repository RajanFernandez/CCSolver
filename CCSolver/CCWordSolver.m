//
//  CCWordSolver.m
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 30/01/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import "CCWordSolver.h"
#import "CCDictionary.h"

@implementation CCWordSolver

+(NSDictionary *)criteriaForWord:(CCWord *)word {
    
    NSMutableDictionary *criteria = [[NSMutableDictionary alloc] init];
    
    // dictionary { char/code : [place indexes] }
    for (NSUInteger i = 0; i < [word.squares count]; i++) {
        
        CCSquare *square = [word.squares objectAtIndex:i];
        
        NSString *key  = nil;
        if ([square containsCharacter]) {
            key = [[NSString stringWithFormat:@"%c", square.character] lowercaseString];
        } else {
            key = [NSString stringWithFormat:@"%lu", (unsigned long)square.codeIndex];
        }
        
        NSMutableSet *places = [criteria objectForKey:key];
        if (places == nil) {
            // Start a new dictionary entry for new letters/unkowns
            places = [NSMutableSet setWithObject:[NSNumber numberWithUnsignedLong:i]];
            [criteria setObject:places forKey:key];
        } else {
            // Add another place to the places array for letters/unkowns that already have a dictionary entry
            [places addObject:[NSNumber numberWithUnsignedLong:i]];
        }
    }
    
    NSDictionary *allCriteria = [NSDictionary dictionaryWithDictionary:criteria];
    
    return allCriteria;
}

+(NSMutableArray *)shortlistForIncompleteWord:(CCWord *)word {
    
    // Get the full list of words
    NSMutableArray *shortlist = [NSMutableArray arrayWithArray:[CCDictionary englishDictionary]];
    
    // Get the criteria for word matching
    NSUInteger length = [word length];
    NSDictionary *allCriteria = [CCWordSolver criteriaForWord:word];
    
    // Remove all words from the list that don't match the criteria
    BOOL noMatch = false;
    for (NSInteger i = [shortlist count] - 1; i >= 0; i--) {
        
        NSString *shortlistWord = shortlist[i];
        noMatch = false;
        
        // Remove words that arn't the right length
        if (![CCWordSolver word:shortlistWord isOfLength:length]) {
            [shortlist removeObjectAtIndex:i];
            continue;
        }
        
        // Remove words that don't have the known letters in place, or that have the known letters out of place
        if (![CCWordSolver word:shortlistWord matchesCriteria:allCriteria]) {
            [shortlist removeObjectAtIndex:i];
        }
    }
    
    return shortlist;
}

+(BOOL)word:(NSString *)word isOfLength:(NSUInteger)length {
    return [word length] == length;
}

+(BOOL)word:(NSString *)word matchesCriteria:(NSDictionary *)criteria {
    
    // Formatter for checking if criteria dictionary keys are letters or numbers
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSArray *criteriaKeys = criteria.allKeys;
    for (NSString *key in criteriaKeys) {
        
        // Array of indexes where the key occurs in the the word
        NSSet *places = [criteria objectForKey:key];
        
        // Try to convert the key to a code cracker integer index
        NSNumber *decimalKey = [formatter numberFromString:key];
        
        if (decimalKey == nil) {
            // Key is a character: Check known letters are in place
            char knownCharacter = [key characterAtIndex:0];
            if (![CCWordSolver word:word hasKnownCharacter:knownCharacter inPlaces:places]) {
                return false;
            }
        } else {
            // Key is a code cracker code index: Check unknown letter patterns
            if (![CCWordSolver word:word hasCommonCharacterInPlaces:places]) {
                return false;
            }
        }
    }
    
    return true;
}

+ (BOOL)word:(NSString *)word hasKnownCharacter:(char)character inPlaces:(NSSet *)places {

    // Check every character in the word
    for (int i = 0; i < [word length]; i++) {
        
        BOOL isKnownCharacter = ([word characterAtIndex:i] == character);
        BOOL isPlaceOfKnownCharacter = false;
        
        for (NSNumber *place in places) {
            if (place.integerValue == i) {
                isPlaceOfKnownCharacter = true;
            }
        }
        
        if (isPlaceOfKnownCharacter != isKnownCharacter) {
            return false;
        }
    }
    
    return true;
}

+(BOOL)word:(NSString *)word hasCommonCharacterInPlaces:(NSSet *)places {
    
    NSNumber *firstPlace = [places anyObject];
    char character = [word characterAtIndex:firstPlace.unsignedLongValue];

    for (int i = 0; i < [word length]; i++) {
        NSNumber *index = [NSNumber numberWithInt:i];
        if ([places containsObject:index] == ([word characterAtIndex:i] != character)) {
            return false;
        }
    }
    
    return true;
}

@end

