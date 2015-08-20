//
//  ComicVineClient.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 16/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface ComicVineClient : NSObject

- (RACSignal *) fetchSuggestedVolumeWithQuery: (NSString *) query;

- (RACSignal *) fetchVolumesWithQuery: (NSString *) query page: (NSUInteger) page;

-(RACSignal *)fetchVolumeDetailWithIdentifier:(NSString *) volumeIdentifier;

-(RACSignal *)fetchCharactersWithIdentifiers:(NSArray *) charactersIdentifiers;

@end
