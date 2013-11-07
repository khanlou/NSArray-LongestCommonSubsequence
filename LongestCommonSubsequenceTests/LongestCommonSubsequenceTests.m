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

- (void)testConvenienceMethod
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"m", @"a", @"b", @"f"];
    
    NSIndexSet *commonIndexes = [first indexesOfCommonElementsWithArray:second];
    
    XCTAssert(commonIndexes.count == 2, @"should match 2 items");
    
    NSArray *expectedResult =  @[@"a", @"b"];
    XCTAssertEqualObjects(expectedResult, [first objectsAtIndexes:commonIndexes], @"indexes should map to the objects that we expect");
}

- (void)testWithInitialObjectsMatching
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"f"];
    
    NSIndexSet *commonIndexes = [first indexesOfCommonElementsWithArray:second];
    
    XCTAssert(commonIndexes.count == 2, @"should match 2 items");
    
    NSArray *expectedResult =  @[@"a", @"b"];
    XCTAssertEqualObjects(expectedResult, [first objectsAtIndexes:commonIndexes], @"indexes should map to the objects that we expect");
}

- (void)testAllObjectsMatching
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d", @"e"];
    
    NSIndexSet *commonIndexes = [first indexesOfCommonElementsWithArray:second];
    
    XCTAssert(commonIndexes.count == 5, @"should match 5 items");
}

- (void)testAllObjectsMatchingWithDifferentLengths
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d"];
    
    NSIndexSet *commonIndexes = [first indexesOfCommonElementsWithArray:second];
    
    XCTAssert(commonIndexes.count == 4, @"should match 4 items");
}

- (void) testCommutativeProperty
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d"];
    
    
    NSIndexSet *commonIndexes = [first indexesOfCommonElementsWithArray:second];
    NSIndexSet *commonIndexesReversed = [second indexesOfCommonElementsWithArray:first];
    
    XCTAssert(commonIndexes.count == 4, @"should match no items");
    XCTAssert(commonIndexesReversed.count == 4, @"should match 4 items, should be commutative");
}


- (void)testObjectsAtEnd
{
    NSArray *first = @[@"a", @"b", @"c", @"d", @"e"];
    NSArray *second = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g"];
    
    NSIndexSet *addedIndexes, *removedIndexes;
    NSIndexSet *commonIndexes = [first indexesOfCommonElementsWithArray:second addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
    
    XCTAssert(commonIndexes.count == 5, @"should match 5 items");
    XCTAssert(addedIndexes.count == 2, @"should match 2 items");
    XCTAssert(removedIndexes.count == 0, @"should match 0 items");
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
    
    XCTAssertEqual(second.count, first.count + addedIndexes.count - removedIndexes.count, @"number of items in the new array should equal the first array's items + the added items - the deleted items");
    
    NSArray *commonObjects = [first objectsAtIndexes:commonIndexes];
    
    NSMutableArray *firstMinusRemovedIndexes = [first mutableCopy];
    [firstMinusRemovedIndexes removeObjectsAtIndexes:removedIndexes];
    
    XCTAssertEqualObjects(commonObjects, firstMinusRemovedIndexes, @"the common objects should be the first array minus the objects at the removed indexes");
}

@end
