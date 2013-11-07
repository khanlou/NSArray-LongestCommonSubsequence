//
//  SKViewController.m
//  LongestCommonSubsequence
//
//  Created by Soroush Khanlou on 11/6/13.
//
//

#import "SKViewController.h"
#import "NSArray+LongestCommonSubsequence.h"

@interface SKViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sourceData;


@end

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self resetDataSource:nil];
    [_tableView reloadData];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleBordered target:self action:@selector(resetDataSource:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Switch" style:UIBarButtonItemStyleBordered target:self action:@selector(changeDataSource:)];
}

- (void) resetDataSource:(id)sender {
    [self switchToNewDataSource: @[@"a", @"b", @"c", @"d", @"e"]];
}

- (void) changeDataSource:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Change Data Source To"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:
                            @"a b c d e",
                            @"1 a b c d e",
                            @"a b c d e f",
                            @"a b c c.5 d e",
                            @"b c d e",
                            @"b c d",
                            @"",
                            nil];
    
    [sheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSArray *components = [title componentsSeparatedByString:@" "];
    [self switchToNewDataSource:components];
}

- (void) switchToNewDataSource:(NSArray*)newSource {
    NSArray *addedIndexes, *removedIndexes;
    
    [_sourceData indexesOfCommonElementsWithArray:newSource addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
    
    self.sourceData = [newSource mutableCopy];
    
    NSMutableArray *indexPathsToAdd = [NSMutableArray array], *indexPathsToDelete = [NSMutableArray array];
    
    [addedIndexes enumerateObjectsUsingBlock:^(NSNumber *index, NSUInteger idx, BOOL *stop) {
        [indexPathsToAdd addObject:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
    }];
    [removedIndexes enumerateObjectsUsingBlock:^(NSNumber *index, NSUInteger idx, BOOL *stop) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:[index integerValue] inSection:0]];
    }];
    
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
