//
//  CharactersViewModel.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 19/8/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;
@class CharacterResultViewModel;

@interface CharactersViewModel : NSObject

@property (strong, nonatomic, readonly) RACSignal *didUpdateCharactersSignal;

-(id)initWithVolumeIdentifier: (NSString *) volumeIdentifier;

-(NSUInteger) numberOfCharacters;

-(CharacterResultViewModel *) resultAtIndex: (NSUInteger) index;

@end
