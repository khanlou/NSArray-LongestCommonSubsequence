# NSArray and Longest Common Subsequence

This is a category on NSArray that finds the indexes of the longest common subsequence with another array.

`UITableView` has built-in methods for adding and removing cells with animations, but it has no way of peeking into your data source to understand how it has changed. Understanding which elements in a list were removed, which stayed the same, and which were added, seems like a thing computers would be really good at. It turns out, it is.

The technique is called the **Longest Common Subsequence**. I wrote a category on `NSArray` to calculate this. For the actual algorithm, I used a bottom-up dynamic programming solution, with results cached in a C matrix. It isn't terribly complex, and I shamelessly stole my implementation from [this page](http://www.ics.uci.edu/~eppstein/161/960229.html). You can also read a more in depth explanation [on Wikipedia](http://en.wikipedia.org/wiki/Longest_common_subsequence_problem).

The algorithm operates in `O(mn)` time, where m and n are the lengths of the two arrays. Determining the equality of objects is done through the `isEquals:` method, so be sure that your implementation of does represent equality for your objects.

Building the table of the lengths of common subsequences is the first step. Once we have our table of subsequence lengths, we can backtrack through it to get the indexes of the common objects. This technique also documented in a few places, including both of the links above. After that, we use the `commonIndexes` to find the `addedIndexes` and the `removedIndexes`.

### Usage

If all you need is the common indexes, there is a convenience method for you:

	- (NSIndexSet*) indexesOfCommonElementsWithArray:(NSArray*)array;
	
Once you have the `NSIndexSet` you can call `-[NSArray objectsAtIndexes:]` to easily get access to the objects themselves.

Of course, this is Cocoa, and we want to be able to use this information with UIKit, namely, `UITableView` and `UICollectionView`. To get indexes for use with the `- insertRowsAtIndexPaths:withRowAnimation:` and `-deleteRowsAtIndexPaths:withRowAnimation:` methods, use the second method provided. It has two `inout` parameters that return the extra data that is needed.

	- (NSIndexSet*) indexesOfCommonElementsWithArray:(NSArray*)array addedIndexes:(NSIndexSet**)addedIndexes removedIndexes:(NSIndexSet**)removedIndexes;

### General Case Implementation

You can see that a sample implementation (for any general set of data!) is pretty simple.

    NSIndexSet *addedIndexes, *removedIndexes;
    
    [oldData indexesOfCommonElementsWithArray:newData addedIndexes:&addedIndexes removedIndexes:&removedIndexes];
    
    self.dataSource = newData;
    
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

### Note about the addedIndexes

The key to finding the right indexes for adding was (as always) [in the Apple documentation](https://developer.apple.com/library/ios/documentation/userexperience/conceptual/tableview_iphone/ManageInsertDeleteRow/ManageInsertDeleteRow.html#//apple_ref/doc/uid/TP40007451-CH10-SW1):

>  [`UITableView`] defers any insertions of rows or sections until after it has handled the deletions of rows or sections.

This means the deleted objects have to be found first. Once they've been removed, we have only the common objects left. We can then compare the new array to the list of common objects, and find the indexes that the new tableview rows will need to be added at.
