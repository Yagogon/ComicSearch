//
//  SuggestionsViewController.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 15/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

@import UIKit;

@protocol SuggestionsViewControllerDelegate;


@interface SuggestionsViewController : UITableViewController<UISearchResultsUpdating>

@property (weak, nonatomic) id<SuggestionsViewControllerDelegate> delegate;

@end

@protocol SuggestionsViewControllerDelegate <NSObject>

- (void) suggestionsViewController:(SuggestionsViewController *)viewController
               didSelectSuggestion:(NSString *)suggestion;

@end
