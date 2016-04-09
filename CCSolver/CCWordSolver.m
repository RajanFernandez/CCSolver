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

// Returns a dictionary of the unknown words criteria
// Dictionary format: { String of the known character or code index : Array of indexes where the character occurs in the word }
//
+(NSDictionary *)criteriaForWord:(CCWord *)word {
    
    NSMutableDictionary *criteria = [[NSMutableDictionary alloc] init];
    
    // dictionary { char/code : [place indexes] }
    for (NSUInteger i = 0; i < [word.squares count]; i++) {
        
        CCSquare *square = [word.squares objectAtIndex:i];
        
        NSString *key  = nil;
        if ([square containsCharacter]) {
            key = [[NSString stringWithFormat:@"%c", square.character] lowercaseString];
        } else {
            key = [NSString stringWithFormat:@"%lu", square.codeIndex];
        }
        
        NSMutableArray *places = [criteria objectForKey:key];
        if (places == nil) {
            // Start a new dictionary entry for new letters/unkowns
            places = [NSMutableArray arrayWithObject:[NSNumber numberWithUnsignedLong:i]];
            [criteria setObject:places forKey:key];
        } else {
            // Add another place to the places array for letters/unkowns that already have a dictionary entry
            [places addObject:[NSNumber numberWithUnsignedLong:i]];
        }
    }
    
    NSDictionary *allCriteria = [NSDictionary dictionaryWithDictionary:criteria];
    
    return allCriteria;
}

// Returns an array of possible words for a given word with unknown letters
//
+(NSMutableArray *)shortlistForIncompleteWord:(CCWord *)word {
    
    // Get the full list of words
    NSMutableArray *shortlist = [NSMutableArray arrayWithArray:[CCDictionary englishDictionary]];
    
    // Get the criteria for word matching
    NSUInteger length = [word length];
    NSDictionary *allCriteria = [CCWordSolver criteriaForWord:word];
    
    // Formatter for checking if criteria dictionary keys are letters or numbers
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    // Remove all words from the list that don't match the criteria
    BOOL noMatch = false;
    for (NSInteger i = [shortlist count] - 1; i >= 0; i--) {
        
        NSString *shortlistWord = shortlist[i];
        noMatch = false;
        
        // Remove words that arn't the right length
        if ([shortlistWord length] != length) {
            [shortlist removeObjectAtIndex:i];
            continue;
        }
        
        // Remove words that don't have the known letters in place, or that have the known letters out of place
        NSArray *criteriaKeys = allCriteria.allKeys;
        for (NSString *key in criteriaKeys) {
            
            // Array of indexes where the key occurs in the the word
            NSArray *places = [allCriteria objectForKey:key];
            
            // Try to convert the key to a code cracker integer index
            NSNumber *decimalKey = [formatter numberFromString:key];
            
            if (decimalKey == nil) {
                // Key is a character: Check known letters are in place
                char knownCharacter = [key characterAtIndex:0];
                if (![CCWordSolver word:shortlistWord hasKnownCharacter:knownCharacter inPlaces:places]) {
                    noMatch = true;
                    break;
                }
            } else {
                // Key is a code cracker code index: Check unknown letter patterns
                if (![CCWordSolver word:shortlistWord hasCommonCharacterInPlaces:places]) {
                    noMatch = true;
                    break;
                }
            }
        }
        if (noMatch) {
            [shortlist removeObjectAtIndex:i];
        }
    }
    
    return shortlist;
}

// Returns true if the input word has the given character at the given indexes and not at other indexes
//
+(BOOL)word:(NSString *)word hasKnownCharacter:(char)character inPlaces:(NSArray *)places {

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

// Returns true if the input word has a common charater at all the given indexes
//
+(BOOL)word:(NSString *)word hasCommonCharacterInPlaces:(NSArray *)places {
    
    NSNumber *firstPlace = places[0];
    char character = [word characterAtIndex:firstPlace.unsignedLongValue];
    
    for (int i = 1; i < [places count]; i++) {
        NSNumber *place = places[i];
        if ([word characterAtIndex:place.unsignedLongValue] != character) {
            return false;
        }
    }
    
    return true;
}

@end

