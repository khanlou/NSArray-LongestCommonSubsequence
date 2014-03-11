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
    

    self.tableView = [[UITableView alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [UIApplication.sharedApplication.keyWindow addSubview:_tableView];
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
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
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

- (void)testAddingTwoNonAdjacentItems
{
    [self resetTableView];
    
    [self switchToNewDataSource:@[@"a", @"a.1", @"b", @"c", @"c.2", @"d", @"e", @"e.3"]];
}

- (void)testReordering
{
    [self resetTableView];
    
    [self switchToNewDataSource:@[@"b", @"e", @"d", @"c", @"a"]];
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
    [_tableView insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:UITableViewRowAnimationNone];
    [_tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
    
    [self verifyCells];
}

- (void) verifyCells
{
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    
    XCTAssert([_tableView numberOfRowsInSection:0] == self.sourceData.count, @"number of rows in table view should equal source data count");
    for (NSUInteger i = 0; i < self.sourceData.count; i++) {
        NSString* cellLabel = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].textLabel.text;
        XCTAssert([cellLabel isEqualToString:self.sourceData[i]], @"result cells should equal expected");
    }
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
