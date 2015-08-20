//
//  SearchResultCell.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 17/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResultViewModel;

@interface SearchResultCell : UITableViewCell

-(void) configureWithSearchResult: (SearchResultViewModel *) searchResult;

@end
