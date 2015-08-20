//
//  SuggestionsViewController.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 15/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import "SuggestionsViewController.h"
#import "SuggestionsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString * const reuseIdentifier = @"cellIdentifier";

@interface SuggestionsViewController ()

@property (strong, nonatomic) SuggestionsViewModel *viewModel;

@end

@implementation SuggestionsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    self.viewModel = [SuggestionsViewModel new];
    
    @weakify(self);
    [self.viewModel.didUpdateSuggestionsSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.viewModel.numberOfSuggestions;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.textLabel.text = [self.viewModel suggestionAtIndex:indexPath.row];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *suggestion = [self.viewModel suggestionAtIndex:indexPath.row];
    
    [self.delegate suggestionsViewController:self
                         didSelectSuggestion:suggestion];
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    self.viewModel.query = searchController.searchBar.text;
    
}

@end
