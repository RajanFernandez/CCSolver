//
//  CCSolverTests.m
//  CCSolverTests
//
//  Created by Rajan Fernandez on 10/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCWordSolver.h"

@interface CCSolverTests : XCTestCase

@property CCWord *testWord;

@end

@implementation CCSolverTests

- (void)setUp {
    [super setUp];
    self.testWord = [[CCWord alloc] init];
    [self.testWord addSquare:[CCSquare squareWithIndex:1 character:'l' row:0 column:0]];
    [self.testWord addSquare:[CCSquare squareWithIndex:2 character:'!' row:0 column:0]];
    [self.testWord addSquare:[CCSquare squareWithIndex:3 character:'%' row:0 column:0]];
    [self.testWord addSquare:[CCSquare squareWithIndex:3 character:'%' row:0 column:0]];
    [self.testWord addSquare:[CCSquare squareWithIndex:4 character:')' row:0 column:0]];
    [self.testWord addSquare:[CCSquare squareWithIndex:5 character:'n' row:0 column:0]];
}

- (void)tearDown {
    self.testWord = nil;
    [super tearDown];
}

/**
 * Check that the solver criteria is generated correctly for an incomplete word.
 */
- (void)testCriteriaGeneration {
    NSDictionary* criteria = [CCWordSolver criteriaForWord:self.testWord];
    // Check the correct number of criteria were generated
    NSUInteger expectedNumberOfCriteria = 5;
    NSUInteger numberOfCritera = criteria.count;
    XCTAssertEqual(numberOfCritera, expectedNumberOfCriteria, "Solver failed to generate the correct number of criteria for the test word. %lu criteria generated, not %lu.", numberOfCritera, expectedNumberOfCriteria);
}

/**
 * Check that the letter matching solver component functions correctly.
 */
- (void)testWordLengthMatchingMethod {
    NSString *word = @"lesson";
    BOOL result = [CCWordSolver word:word isOfLength:6];
    XCTAssertTrue(result, "Solver failed to detect that a word was the correct length.");
    result = [CCWordSolver word:word isOfLength:3];
    XCTAssertFalse(result, "Solver failed to detect that a word was the incorrect length.");
}

/**
 * Check that the letter matching solver component functions correctly.
 */
- (void)testCriteriaMatchingMethod {
    // test for input string: l$//*n
    NSString *word = @"lesson";
    NSDictionary *criteria = @{
                               @"l" : [NSSet setWithArray:@[@0]],
                               @"1" : [NSSet setWithArray:@[@1]],
                               @"2" : [NSSet setWithArray:@[@2, @3]],
                               @"3" : [NSSet setWithArray:@[@4]],
                               @"n" : [NSSet setWithArray:@[@5]],
                               };
    BOOL result = [CCWordSolver word:word matchesCriteria:criteria];
    XCTAssertTrue(result, "Solver failed to detect that a word matches a set of criteria.");
    word = @"lessen";
    result = [CCWordSolver word:word matchesCriteria:criteria];
    XCTAssertFalse(result, "Solver failed to detect that a word does not match a set of criteria.");
}

/**
 * Check that the letter matching solver component functions correctly.
 */
- (void)testKnownCharactersInPlacesMethod {
    NSString *word = @"lesson";
    BOOL result = [CCWordSolver word:word hasKnownCharacter:'n' inPlaces:@[@5]];
    XCTAssertTrue(result, "Solver failed to detect a character in the correct position in a word.");
    result = [CCWordSolver word:word hasKnownCharacter:'n' inPlaces:@[@2, @3, @4]];
    XCTAssertFalse(result, "Solver failed to detect a character in incorrect positions in a word.");
}

/**
 * Check that the character pattern matching function works correctly.
 */
- (void)testCharacterPatternMatchingMethod {
    NSString *word = @"lesson";
    BOOL result = [CCWordSolver word:word hasCommonCharacterInPlaces:[NSSet setWithArray:@[@2, @3]]];
    XCTAssertTrue(result, "Solver failed to detect a common character at given positions in a word");
    result = [CCWordSolver word:word hasCommonCharacterInPlaces:[NSSet setWithArray:@[@2, @5]]];
    XCTAssertFalse(result, "Solver failed to detect a common character at incorrect positions in a word");
    result = [CCWordSolver word:word hasCommonCharacterInPlaces:[NSSet setWithArray:@[@2]]];
    XCTAssertFalse(result, "Solver failed to detect a common character at an unspecified position.");
}

/**
 * Check that the word solver returns the correct number of solutions with a standard test word: LESSON.
 */
- (void)testSolverWithTestWord {
    [self.testWord updateSolutions];
    NSUInteger expectedNumberOfResults = 3;
    NSUInteger numberOfSolutions = self.testWord.solutions.count;
    XCTAssertTrue(numberOfSolutions == expectedNumberOfResults, "Solver returned %lu results for input 'l!\%\%)n', expected %lu results.", numberOfSolutions, expectedNumberOfResults);
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
