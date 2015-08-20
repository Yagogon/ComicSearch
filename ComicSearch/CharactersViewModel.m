//
//  CharactersViewModel.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 19/8/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import "CharactersViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ComicVineClient.h"
#import "Response.h"
#import "Character.h"
#import "CharacterResultViewModel.h"

@interface CharactersViewModel ()

@property (copy, nonatomic) NSArray *characters;

@end

@implementation CharactersViewModel


-(id)initWithVolumeIdentifier: (NSString *) volumeIdentifier {
    
    
    
    if (self = [super init]) {
        
        RACSignal *volumeSignal = [self fetchVolumeDetailWithIdentifier:volumeIdentifier];
        
        @weakify(self);
        RACSignal *charactersSignal = [volumeSignal flattenMap:^RACStream *(NSArray *identifiers) {
            @strongify(self);
            return [self fetchCharactersWithIdentifiers:identifiers];
        }];

        RAC(self, characters) = [charactersSignal catch:^RACSignal *(NSError *error) {
            return [RACSignal return:@[error.localizedDescription]];
            
        }];
        
        _didUpdateCharactersSignal = [RACObserve(self, characters) mapReplace:nil];
        
        
    }
    
    return self;
    
}


-(RACSignal *) fetchVolumeDetailWithIdentifier: (NSString *) identifier {
    
    
    ComicVineClient *client = [ComicVineClient new];
    
    return [[client fetchVolumeDetailWithIdentifier:identifier] map:^id(Response  *response) {
       
        NSMutableArray *charactersIdentifiers = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in response.results[@"characters"]) {
            NSString *identifier = dict[@"id"];
            [charactersIdentifiers addObject:identifier];
        }
        
        return charactersIdentifiers;
    }];
    
}

-(RACSignal *) fetchCharactersWithIdentifiers: (NSArray *) identifiers {
    
    ComicVineClient *client = [ComicVineClient new];
    
    return [[client fetchCharactersWithIdentifiers:identifiers] map:^id(Response  *response) {
        
        NSMutableArray *characters = [[NSMutableArray alloc] init];
        
        for (Character *character in response.results) {
            [characters addObject:character];
        }
        
        return characters;
    }];

    
    
}

#pragma mark Table view datasource

-(NSUInteger)numberOfCharacters {
    
    return self.characters.count;
}

-(CharacterResultViewModel *)resultAtIndex:(NSUInteger)index {
    
    Character *character = [self.characters objectAtIndex:index];
    
    return [[CharacterResultViewModel alloc] initWithName:character.name
                                                 imageURL:character.imageURL];
    
}

@end
