//
//  CCSolverTests.m
//  CCSolverTests
//
//  Created by Rajan Fernandez on 10/04/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CCDictionary.h"

@interface CCSolverTests : XCTestCase

@end

@implementation CCSolverTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDictionaryLoads {
    NSArray* dict = [CCDictionary englishDictionary];
    NSUInteger expectedEntries = 109582;
    NSUInteger entries = [dict count];
    XCTAssertTrue(entries == expectedEntries, @"The dictionary should have %lu entries when loaded correctly, not %lu.", expectedEntries, entries);
    
    // Check the first dictionary entry was read correctly
    NSString *expectedFirstWord = @"a";
    NSString * firstWord = [dict firstObject];
    XCTAssertTrue([firstWord isEqual:expectedFirstWord], @"Expected the first entry in the dictionary to be '%@', not %@", expectedFirstWord, firstWord);
    
    // Check the last dictionary entry was read correctly
    NSString *expectedLastWord = @"zyzzyvas";
    NSString *lastWord = [dict lastObject];
    XCTAssertTrue([lastWord isEqual:expectedLastWord], @"Expected the last entry in the dictionary to be '%@', not %@", expectedLastWord, lastWord);
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
