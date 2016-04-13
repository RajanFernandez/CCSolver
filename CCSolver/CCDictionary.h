//
//  CCDictionary.h
//  Code Cracker Solver
//
//  Created by Rajan Fernandez on 7/02/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCDictionary : NSObject

/*!
 * @brief Loads a dictionary of english words from a txt file and returns the words in an array.
 */
+(NSArray *)englishDictionary;

/*!
 * @brief Returns true if the given word is in the dictionary.
 *
 * @param word The word to check is in the dictionary.
 */
+(BOOL)isInEnglishDictionary:(NSString *)word;

@end
