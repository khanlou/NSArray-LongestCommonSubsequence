//
//  NSArray+LongestCommonSubsequence.h
//  LongestCommonSubsequence
//
//  Created by Soroush Khanlou on 11/6/13.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (LongestCommonSubsequence)

- (NSIndexSet*) indexesOfCommonElementsWithArray:(NSArray*)array addedIndexes:(NSArray**)addedIndexes removedIndexes:(NSArray**)removedIndexes;
- (NSIndexSet*) indexesOfCommonElementsWithArray:(NSArray*)array;


@end
