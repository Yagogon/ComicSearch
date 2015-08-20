//
//  SearchViewModel.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 17/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SearchResultViewModel;
@class  RACSignal;

@interface SearchViewModel : NSObject

@property (copy, nonatomic) NSString *query;
@property (strong, nonatomic, readonly) RACSignal *didUpdateResults;
@property (nonatomic, readonly) NSUInteger numberOfResults;

- (SearchResultViewModel *) resultAtIndex: (NSUInteger)index;

- (void) fetchMoreResults;

@end
