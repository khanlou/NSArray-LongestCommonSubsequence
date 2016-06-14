//
//  LongestCommonSubsequenceTests.m
//  LongestCommonSubsequenceTests
//
//  Created by Soroush Khanlou on 11/6/13.
//
//

#import <XCTest/XCTest.h>
#import "NSArray+LongestCommonSubsequence.h"

#define LCSTestCompareCount(firstArray, secondArray, commonCount) ({\
    NSIndexSet *addedIndexes, *removedIndexes;\
    NSIndexSet *commonIndexes = [firstArray indexesOfCommonElementsWithArray:secondArray addedIndexes:&addedIndexes removedIndexes:&removedIndexes];\
    \
    XCTAssertEqual((int)commonIndexes.count, (int)commonCount, @"number of common items mismatch");\
    XCTAssertEqual(secondArray.count, firstArray.count + addedIndexes.count - removedIndexes.count, @"number of items in the new array should equal the first array's items + the added items - the deleted items");\
})

#define LCSTestReplicable(firstArray, secondArray) ({\
    NSIndexSet *addedIndexes, *removedIndexes;\
    [firstArray indexesOfCommonElementsWithArray:secondArray addedIndexes:&addedIndexes removedIndexes:&removedIndexes];\
    NSMutableArray *replica = [firstArray mutableCopy];\
    [replica removeObjectsAtIndexes:removedIndexes];\
    NSArray *addedObjects = [secondArray objectsAtIndexes:addedIndexes];\
    [replica insertObjects:addedObjects atIndexes:addedIndexes];\
    XCTAssert([secondArray isEqualToArray:replica], @"Expecting to be able to replicate the second array using the first - removed + added items");\
})


@interface LongestCommonSubsequenceTests : XCTestCase

@end

@implementation LongestCommonSubsequenceTests

- (void)testSimpleCase
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"m", @"a", @"b", @"f"];
    
    LCSTestCompareCount(first, second, 2);
    LCSTestReplicable(first, second);
}

- (void)testWithInitialObjectsMatching
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"f"];
    
    LCSTestCompareCount(first, second, 2);
    LCSTestReplicable(first, second);
}

- (void)testAllObjectsMatching
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d", @"e"];
    
    LCSTestCompareCount(first, second, 5);
    LCSTestReplicable(first, second);
}

- (void)testRemoveAll
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[];
    
    LCSTestCompareCount(first, second, 0);
    LCSTestReplicable(first, second);
}

- (void)testAddAll
{
    NSArray *first = @[];
    NSArray *second = @[@"a", @"b", @"c", @"d", @"e"];
    
    LCSTestCompareCount(first, second, 0);
    LCSTestReplicable(first, second);
}

- (void)testAllObjectsMatchingWithDifferentLengths
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d"];
    
    LCSTestCompareCount(first, second, 4);
    LCSTestReplicable(first, second);
}

- (void)testCommutativeProperty
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d"];
    
    LCSTestCompareCount(first, second, 4);
    LCSTestCompareCount(second, first, 4);
    
    LCSTestReplicable(first, second);
    LCSTestReplicable(second, first);
}

- (void)testObjectsAtEnd
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g"];
    
    LCSTestCompareCount(first, second, 5);
    LCSTestReplicable(first, second);
}

- (void)testOnlyEqual
{
    NSArray *first = @[@"a", @"a", @"a", @"a", @"a"];
    NSArray *second = @[@"a", @"a", @"a", @"a", @"a"];
    
    LCSTestCompareCount(first, second, 5);
    LCSTestReplicable(first, second);
}

- (void)testManyEqual
{
    NSArray *first = @[@"a", @"a", @"a", @"a", @"a"];
    NSArray *second = @[@"a", @"a", @"b", @"a", @"a"];
    
    LCSTestCompareCount(first, second, 4);
    LCSTestReplicable(first, second);
}

- (void)testOddCountReversed
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"e", @"d", @"c", @"b", @"a"];
    
    LCSTestCompareCount(first, second, 1);
    LCSTestReplicable(first, second);
}

- (void)testEvenCountReversed
{
    NSArray *first = @[@"a", @"b", @"d", @"e"];
    NSArray *second = @[@"e", @"d", @"b", @"a"];
    
    LCSTestCompareCount(first, second, 1);
    LCSTestReplicable(first, second);
}

- (void)testPseudoPairs
{
    NSArray *first = @[@"a", @"a", @"b", @"b", @"c"];
    NSArray *second = @[@"a", @"a", @"b", @"b", @"c"];
    
    LCSTestCompareCount(first, second, 5);
    LCSTestReplicable(first, second);
}

- (void)testPseudoPairsFlipped
{
    NSArray *first = @[@"a", @"a", @"b", @"b", @"c"];
    NSArray *second = @[@"c", @"b", @"b", @"a", @"a"];
    
    LCSTestCompareCount(first, second, 2);
    LCSTestReplicable(first, second);
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

@end
