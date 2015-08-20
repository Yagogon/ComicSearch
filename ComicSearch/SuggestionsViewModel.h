//
//  SuggestionsViewModel.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 15/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface SuggestionsViewModel : NSObject

@property (copy, nonatomic) NSString *query;

@property (nonatomic) NSUInteger numberOfSuggestions;

@property (strong, nonatomic, readonly) RACSignal *didUpdateSuggestionsSignal;

-(NSString *)suggestionAtIndex:(NSUInteger)index;

@end
