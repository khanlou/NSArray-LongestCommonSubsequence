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

    const NSInteger firstDimension = self.count + 1;

    NSInteger **lengths = calloc(firstDimension, sizeof(NSInteger*));

    if(lengths == NULL) {
        [[self class] raiseMallocExceptionWithBytes: firstDimension * sizeof(NSInteger*) * CHAR_BIT / 8];
    }

    const NSInteger secondDimension = array.count + 1;

    for(NSInteger i = 0; i < firstDimension; i++) {
      lengths[i] = calloc(secondDimension, sizeof(NSInteger));

      if(lengths[i] == NULL) {
          [[self class] raiseMallocExceptionWithBytes: secondDimension * sizeof(NSInteger) * CHAR_BIT / 8];
      }
    }

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

    for(NSInteger i = 0; i < firstDimension; i++) {
      free(lengths[i]);
    }

    free(lengths);

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

+ (void) raiseMallocExceptionWithBytes: (long long) bytes {
    NSString* const bytesString = [NSByteCountFormatter stringFromByteCount: bytes countStyle: NSByteCountFormatterCountStyleMemory];

    NSString* const format = [NSString stringWithFormat: @"Unable to allocate %@.", bytesString];

    [NSException raise: NSMallocException format: @"%@", format];
}

@end
