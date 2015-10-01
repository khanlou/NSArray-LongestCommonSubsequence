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
    
    NSIndexSet *addedIndexes, *removedIndexes;
    
    NSIndexSet *commonIndexes = [first indexesOfCommonElementsWithArray:second addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
    
    XCTAssert(commonIndexes.count == 2, @"should match 2 items");
    
    NSArray *expectedResult =  @[@"a", @"b"];
    XCTAssertEqualObjects(expectedResult, [first objectsAtIndexes:commonIndexes], @"indexes should map to the objects that we expect");
    
    // removed indexes ∪ common indexes = all first indexes
    NSIndexSet *allFirstIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 5)];
    NSMutableIndexSet *removedPlusCommon = [removedIndexes mutableCopy];
    [removedPlusCommon addIndexes:commonIndexes];
    XCTAssertEqualObjects(allFirstIndexes, removedPlusCommon);
    
    // added indexes = (0, 3)
    NSMutableIndexSet *expectedAddedIndexes = [NSMutableIndexSet indexSet];
    [expectedAddedIndexes addIndex:0];
    [expectedAddedIndexes addIndex:3];
    XCTAssertEqualObjects(addedIndexes, expectedAddedIndexes);
    
    // removed indexes = (2-4)
    NSMutableIndexSet *expectedRemovedIndexes = [NSMutableIndexSet indexSet];
    [expectedRemovedIndexes addIndexesInRange:NSMakeRange(2, 3)];
    XCTAssertEqualObjects(removedIndexes, expectedRemovedIndexes);
    
    XCTAssertEqual(second.count, first.count + addedIndexes.count - removedIndexes.count, @"number of items in the new array should equal the first array's items + the added items - the deleted items");
    
    NSArray *commonObjects = [first objectsAtIndexes:commonIndexes];
    
    
    
    NSMutableArray *firstMinusRemovedIndexes = [first mutableCopy];
    [firstMinusRemovedIndexes removeObjectsAtIndexes:removedIndexes];
    
    XCTAssertEqualObjects(commonObjects, firstMinusRemovedIndexes, @"the common objects should be the first array minus the objects at the removed indexes");
    
    // first - removed + added = second
    NSMutableArray *firstMinusRemovedPlusAdded = [first mutableCopy];
    [firstMinusRemovedPlusAdded removeObjectsAtIndexes:removedIndexes];
    NSArray *addedObjects = [second objectsAtIndexes:addedIndexes];
    [firstMinusRemovedPlusAdded insertObjects:addedObjects atIndexes:addedIndexes];
    XCTAssertEqualObjects(firstMinusRemovedPlusAdded, second);
}

- (void) compareArray:(NSArray*)firstArray toArray:(NSArray*)secondArray expectingMatches:(NSInteger)matches {
    NSIndexSet *addedIndexes, *removedIndexes;
    
    NSIndexSet *commonIndexes = [firstArray indexesOfCommonElementsWithArray:secondArray addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
    
    XCTAssert(commonIndexes.count == matches, @"common index mismatch");
    
    
    XCTAssertEqual(secondArray.count, firstArray.count + addedIndexes.count - removedIndexes.count, @"number of items in the new array should equal the first array's items + the added items - the deleted items");
}

@end
