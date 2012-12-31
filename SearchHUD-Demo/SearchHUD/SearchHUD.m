//
//  SearchHUD.m
//  SearchHUD-Demo
//
//  Created by Pradyumna Doddala on 31/12/12.
//  Copyright (c) 2012 Pradyumna Doddala. All rights reserved.
//

#import "SearchHUD.h"

@interface SearchHUD ()

@property (nonatomic, strong) NSArray *revisedList;

- (IBAction)tappedOnClose:(id)sender;
@end

@implementation SearchHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithSearchList:(NSArray *)list andDelegate:(id)aDelegate {
    CGRect frame = [[UIScreen mainScreen] bounds];
//    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"SearchHUD" owner:self options:nil] lastObject];
    [self setFrame:frame];
    if (self) {
        // Initialization code
        _delegate = aDelegate;
        _searchList = list;
        _revisedList = list;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.revisedList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //assign cell properties
    cell.textLabel.text = [self.revisedList objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Tableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *selectedItem = [self.revisedList objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndex:)]) {
        int index = [self.searchList indexOfObject:selectedItem];
        [self.delegate didSelectRowAtIndex:index];
    } else {
        NSLog(@"Sorry didSelectRowAtIndex: not implemented");
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        [self.delegate didSelectItem:selectedItem];
    } else {
        NSLog(@"Sorry didSelectItem: not implemented");
    }
}

#pragma mark -
#pragma mark SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        _revisedList = self.searchList;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginsWith[cd] %@", searchText];
        _revisedList = [self.searchList filteredArrayUsingPredicate:predicate];
    }
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _revisedList = self.searchList;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Actions

- (IBAction)tappedOnClose:(id)sender {
    [UIView animateWithDuration:0.30 animations:^{
        self.alpha = 0.1f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
