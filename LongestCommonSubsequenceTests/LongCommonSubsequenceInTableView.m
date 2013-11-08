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

@property (nonatomic, strong) NSArray *sourceData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LongCommonSubsequenceInTableView

- (void)setUp
{
    [super setUp];
    

    self.tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self resetTableView];
}

- (void)tearDown
{
    self.tableView = nil;
    [super tearDown];
}

- (void) resetTableView {
    self.sourceData = @[@"a", @"b", @"c", @"d", @"e"];
    [_tableView reloadData];
}

- (void)testRemovingOneItem
{
    [self resetTableView];
    
    [self switchToNewDataSource:@[@"a", @"b", @"d", @"e"]];
}

- (void)testRemovingFirstItem
{
    [self resetTableView];
    
    [self switchToNewDataSource:@[@"b", @"c", @"d", @"e"]];
}

- (void)testRemovingTwoItems
{
    [self resetTableView];
    
    [self switchToNewDataSource:@[@"a", @"b", @"d"]];
    
}

- (void) testRemovingAllItems
{
    [self resetTableView];
    [self switchToNewDataSource:@[]];
}

- (void)testAddingOneItem
{
    [self resetTableView];
    
    [self switchToNewDataSource:@[@"a", @"b", @"c", @"d", @"e", @"f"]];
    
}

- (void)testAddingFirstItem
{
    [self resetTableView];
    
    [self switchToNewDataSource:@[@"1", @"a", @"b", @"c", @"d", @"e"]];
    
}

- (void)testAddingTwoItems
{
    [self resetTableView];
    
    [self switchToNewDataSource:@[@"a", @"b", @"c", @"d", @"e", @"f", @"g"]];
    
}

- (void)testSwitchingOneItem
{
    [self resetTableView];
    
    [self switchToNewDataSource:@[@"a", @"b", @"c", @"d", @"f"]];
    
}



- (void) switchToNewDataSource:(NSArray*)newSource {
    NSIndexSet *addedIndexes, *removedIndexes;
    
    [_sourceData indexesOfCommonElementsWithArray:newSource addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
    
    self.sourceData = newSource;
    
    NSMutableArray *indexPathsToAdd = [NSMutableArray array], *indexPathsToDelete = [NSMutableArray array];
    
    [addedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPathsToAdd addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    [removedIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
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
