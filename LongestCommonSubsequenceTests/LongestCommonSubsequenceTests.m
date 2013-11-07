//
//  LongestCommonSubsequenceTests.m
//  LongestCommonSubsequenceTests
//
//  Created by Soroush Khanlou on 11/6/13.
//
//

#import <XCTest/XCTest.h>
#import "NSArray+LongestCommonSubsequence.h"

@interface LongestCommonSubsequenceTests : XCTestCase

@end

@implementation LongestCommonSubsequenceTests

- (void)testSimpleCase
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"m", @"a", @"b", @"f"];
    
    [self compareArray:first toArray:second expectingMatches:2];
}

- (void)testWithInitialObjectsMatching
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"f"];
    
    [self compareArray:first toArray:second expectingMatches:2];
}

- (void)testAllObjectsMatching
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d", @"e"];
    
    [self compareArray:first toArray:second expectingMatches:5];
}

- (void)testRemoveAll
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[];
    
    [self compareArray:first toArray:second expectingMatches:0];
}

- (void)testAddAll
{
    NSArray *first = @[];
    NSArray *second = @[@"a", @"b", @"c", @"d", @"e"];
    
    [self compareArray:first toArray:second expectingMatches:0];
}


- (void)testAllObjectsMatchingWithDifferentLengths
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d"];

    [self compareArray:first toArray:second expectingMatches:4];
}

- (void) testCommutativeProperty
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d"];
    
    [self compareArray:first toArray:second expectingMatches:4];
    [self compareArray:second toArray:first expectingMatches:4];
}


- (void)testObjectsAtEnd
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g"];
    
    [self compareArray:first toArray:second expectingMatches:5];
}

- (void)testFullMethod
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"m", @"a", @"b", @"f"];
    
    NSArray *addedIndexes, *removedIndexes;
    
    NSIndexSet *commonIndexes = [first indexesOfCommonElementsWithArray:second addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
    
    XCTAssert(commonIndexes.count == 2, @"should match 2 items");
    
    NSArray *expectedResult =  @[@"a", @"b"];
    XCTAssertEqualObjects(expectedResult, [first objectsAtIndexes:commonIndexes], @"indexes should map to the objects that we expect");
    
    XCTAssertEqual(second.count, first.count + addedIndexes.count - removedIndexes.count, @"number of items in the new array should equal the first array's items + the added items - the deleted items");
    
    NSArray *commonObjects = [first objectsAtIndexes:commonIndexes];
    
    
    NSMutableIndexSet *indexesOfRemovedObjects = [NSMutableIndexSet indexSet];
    [removedIndexes enumerateObjectsUsingBlock:^(NSNumber *index, NSUInteger idx, BOOL *stop) {
        [indexesOfRemovedObjects addIndex:[index integerValue]];
    }];
    
    NSMutableArray *firstMinusRemovedIndexes = [first mutableCopy];
    [firstMinusRemovedIndexes removeObjectsAtIndexes:indexesOfRemovedObjects];
    
    XCTAssertEqualObjects(commonObjects, firstMinusRemovedIndexes, @"the common objects should be the first array minus the objects at the removed indexes");
}

- (void) compareArray:(NSArray*)firstArray toArray:(NSArray*)secondArray expectingMatches:(NSInteger)matches {
    NSArray *addedIndexes, *removedIndexes;
    
    NSIndexSet *commonIndexes = [firstArray indexesOfCommonElementsWithArray:secondArray addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
    
    XCTAssert(commonIndexes.count == matches, @"common index mismatch");
    
    
    XCTAssertEqual(secondArray.count, firstArray.count + addedIndexes.count - removedIndexes.count, @"number of items in the new array should equal the first array's items + the added items - the deleted items");
}

@end
