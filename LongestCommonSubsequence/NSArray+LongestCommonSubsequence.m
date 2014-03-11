//
//  NSArray+LongestCommonSubsequence.m
//  LongestCommonSubsequence
//
//  Created by Soroush Khanlou on 11/6/13.
//
//

#import "NSArray+LongestCommonSubsequence.h"

@implementation NSArray (LongestCommonSubsequence)

- (NSIndexSet*) indexesOfCommonElementsWithArray:(NSArray*)array {
    return [self indexesOfCommonElementsWithArray:array addedIndexes:nil removedIndexes:nil];
}

- (NSIndexSet*) indexesOfCommonElementsWithArray:(NSArray*)array addedIndexes:(NSIndexSet**)addedIndexes removedIndexes:(NSIndexSet**)removedIndexes {
    
    NSInteger lengths[self.count+1][array.count+1];
    
    for (NSInteger i = self.count; i >= 0; i--) {
        for (NSInteger j = array.count; j >= 0; j--) {
            
            if (i == self.count || j == array.count) {
                lengths[i][j] = 0;
            } else if ([self[i] isEqual:array[j]]) {
                lengths[i][j] = 1 + lengths[i+1][j+1];
            } else {
                lengths[i][j] = MAX(lengths[i+1][j], lengths[i][j+1]);
            }
        }
    }
    
    NSMutableIndexSet *commonIndexes = [NSMutableIndexSet indexSet];
    
    for (NSInteger i = 0, j = 0 ; i < self.count && j < array.count; ) {
        if ([self[i] isEqual:array[j]]) {
            [commonIndexes addIndex:i];
            i++; j++;
        } else if (lengths[i+1][j] >= lengths[i][j+1]) {
            i++;
        } else {
            j++;
        }
    }
    
    if (removedIndexes) {
        NSMutableIndexSet *_removedIndexes = [NSMutableIndexSet indexSet];
        
        for (NSInteger i = 0; i < self.count; i++) {
            if (![commonIndexes containsIndex:i]) {
                [_removedIndexes addIndex:i];
            }
        }
        *removedIndexes = _removedIndexes;
    }
    
    
    if (addedIndexes) {
        NSArray *commonObjects = [self objectsAtIndexes:commonIndexes];
        
        NSMutableIndexSet *_addedIndexes = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0, j = 0; i < commonObjects.count || j < array.count; ) {
            if (i < commonObjects.count && j < array.count && [commonObjects[i] isEqual:array[j]]) {
                i++;
                j++;
            } else {
                [_addedIndexes addIndex:j];
                j++;
            }
        }
        
        *addedIndexes = _addedIndexes;
    }
    return commonIndexes;
    
}

@end
