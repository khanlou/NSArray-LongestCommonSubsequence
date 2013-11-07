//
//  LongCommonSubsequenceInTableView.m
//  LongestCommonSubsequence
//
//  Created by Soroush Khanlou on 11/7/13.
//
//

#import <XCTest/XCTest.h>
#import "NSArray+LongestCommonSubsequence.h"


@interface LongCommonSubsequenceInTableView : XCTestCase <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *sourceData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LongCommonSubsequenceInTableView

- (void)setUp
{
    [super setUp];
    
    self.sourceData = [@[@"a", @"b", @"c", @"d", @"e"] mutableCopy];

    self.tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView reloadData];
    
    NSLog(@"done");
}

- (void)tearDown
{
    self.tableView = nil;
    [super tearDown];
}

- (void)testChangingDataSourcesDynamically
{
    NSMutableArray *newSourceData = [@[@"a", @"b", @"d", @"e", @"f"] mutableCopy];
    
    NSIndexSet *addedIndexes, *removedIndexes;
    
    NSIndexSet *commonIndexes = [_sourceData indexesOfCommonElementsWithArray:newSourceData addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
    
    XCTAssert(commonIndexes.count, @"has some common items");

    self.sourceData = newSourceData;
    
    NSMutableArray *indexPathsToAdd = [NSMutableArray array], *indexPathsToDelete = [NSMutableArray array];
    
    [addedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPathsToAdd addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    [removedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    
    NSLog(@"delete: %@", indexPathsToDelete);
    NSLog(@"add: %@", indexPathsToAdd);
    
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
    
    
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	[self configureCell:cell forRowAtIndexPath:indexPath];
	
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [_sourceData objectAtIndex:indexPath.row];
}

@end
