//
//  AGTSearchViewController.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 15/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import "AGTSearchViewController.h"
#import "SuggestionsViewController.h"
#import "SearchViewModel.h"
#import "SearchResultCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "CharactersViewController.h"
#import "SearchResultViewModel.h"

@interface AGTSearchViewController () <SuggestionsViewControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) SearchViewModel *viewModel;

@end

@implementation AGTSearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.viewModel = [SearchViewModel new];
    
    @weakify(self);
    [self.viewModel.didUpdateResults subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.viewModel.numberOfResults;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    SearchResultViewModel *result = [self.viewModel resultAtIndex:indexPath.row];
    
    [cell configureWithSearchResult:result];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.viewModel.numberOfResults - 1) {
        
        [self.viewModel fetchMoreResults];
    }
    
}

#pragma mark Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultViewModel *volume = [self.viewModel resultAtIndex:indexPath.row];

    CharactersViewController *vc = [[CharactersViewController alloc] initWithVolumeIdentifier:volume.identifier style:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];

    
}

#pragma mark - Actions

-(IBAction)presentSuggestions:(id)sender {
    
    SuggestionsViewController *suggestionsVC = [SuggestionsViewController new];
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:suggestionsVC];
    
    searchController.searchResultsUpdater = suggestionsVC;
    searchController.hidesNavigationBarDuringPresentation = NO;
    
    suggestionsVC.delegate = self;
    searchController.searchBar.delegate = self;
    
    [self presentViewController:searchController
                       animated:YES
                     completion:nil];
}

#pragma mark - SuggestionsViewControllerDelegate

-(void)suggestionsViewController:(SuggestionsViewController *)viewController
             didSelectSuggestion:(NSString *)suggestion {
    
    NSLog(@"didSelectSuggestion: %@", suggestion);
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    self.viewModel.query = suggestion;
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    self.viewModel.query = searchBar.text;
}

@end
