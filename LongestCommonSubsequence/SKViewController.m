//
//  SKViewController.m
//  LongestCommonSubsequence
//
//  Created by Soroush Khanlou on 11/6/13.
//
//

#import "SKViewController.h"
#import "NSArray+LongestCommonSubsequence.h"

@interface SKViewController ()

@end

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray *first = [@[@"a", @"b", @"c", @"d", @"e"] mutableCopy];
    NSArray *second = @[@"m", @"a", @"b", @"f"];

    NSIndexSet *addedIndexes, *removedIndexes;
    
    NSIndexSet *commonIndexes = [first indexesOfCommonElementsWithArray:second addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
    
    NSLog(@"longest common subsequence: %@", [first objectsAtIndexes:commonIndexes]);
    
    
    NSLog(@"added: %@", addedIndexes);
    
    NSLog(@"removed: %@", [first objectsAtIndexes:removedIndexes]);
}

@end
