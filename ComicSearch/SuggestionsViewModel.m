//
//  SuggestionsViewModel.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 15/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import "SuggestionsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ComicVineClient.h"
#import "Response.h"
#import "Volume.h"

@interface SuggestionsViewModel ()

@property (copy, nonatomic) NSArray *suggestions;

@end
@implementation SuggestionsViewModel


#pragma mark - Init

-(instancetype)init {
    
    if (self = [super init]) {
        
        RACSignal *input = RACObserve(self, query);
        input = [input filter:^BOOL(NSString *value) {
            return value.length > 2;
        }];
        
        // Se queda con la última señal pasado el intervalo
        // El intervalo se cuenta entre señal y señal
        input = [input throttle:.4];
        
        [input subscribeNext:^(NSString *value) {
            NSLog(@"input : %@", value);
        }];
        
        // romper referencias circulares, con la anotación -> ReactiveCocoa
        //SuggestionsViewModel * __weak weakSelf = self;
        @weakify(self);
        RACSignal *suggestionsSignal = [input flattenMap:^RACStream *(NSString *query) {
            // SuggestionsViewModel *strongSelf  = weakSelf;
            @strongify(self);
            return [self fetchSuggestionsWithQuery:query];
        }];
        
        RAC(self, suggestions) = [suggestionsSignal catch:^RACSignal *(NSError *error) {
            return [RACSignal return:@[error.localizedDescription]];
            
        }];
        
        _didUpdateSuggestionsSignal = [RACObserve(self, suggestions) mapReplace:nil];
        
        // Otra forma
        
        //_didUpdateSuggestionsSignal = [suggestionsSignal mapReplace:nil];
        
    }
    
    return self;
}

-(NSUInteger)numberOfSuggestions {
    return self.suggestions.count;
}

-(NSString *)suggestionAtIndex:(NSUInteger)index {
    
    return self.suggestions[index];
}

#pragma mark - Private

- (RACSignal *) fetchSuggestionsWithQuery: (NSString *) query {
    
    ComicVineClient *client = [ComicVineClient new];
    
    return [[[client fetchSuggestedVolumeWithQuery:query] map:^id(Response *response) {
        
        NSArray *volumes = response.results;
        
        return [volumes.rac_sequence foldLeftWithStart:[NSMutableArray array]
                                                reduce:^id(NSMutableArray *titles, Volume *value) {
                                                    
                                                    if (![titles containsObject:value.title]) {
                                                        [titles addObject:value.title];
                                                    }
                                                    return  titles;
                                                }];
        
        //        NSMutableArray *titles = [NSMutableArray array];
        //
        //        for (Volume *volume in volumes) {
        //
        //            if ([titles containsObject:volume.title]) {
        //                continue;
        //            }
        //            [titles addObject:volume.title];
        //        }
        //
        //        return titles;
        
        //        return [volumes.rac_sequence map:^id(Volume *volume) {
        //            return volume.title;
        //        }].array;
        // La señal que devuelve va en el hilo principal
    }] deliverOnMainThread];
}

@end
