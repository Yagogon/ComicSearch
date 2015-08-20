//
//  ComicVineClient.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 16/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

//OHHTTPStubs mock peticiones HTTP

#import "ComicVineClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>
#import "Response.h"
#import "Volume.h"
#import "Character.h"

// Parámetros obligatorios petición
static NSString const *APIKEY = @"75d580a0593b7320727309feb6309f62def786cd";
static NSString const *format = @"json";

@interface ComicVineClient ()

@property (strong, nonatomic) AFHTTPRequestOperationManager * requestManager;

@end

@implementation ComicVineClient


-(instancetype)init {
    
    if (self = [super init]) {
        
        _requestManager = [[AFHTTPRequestOperationManager alloc]
                           initWithBaseURL:[NSURL URLWithString:@"http://www.comicvine.com/api"]];
        
    }
    
    return self;
    
}


- (RACSignal *) fetchSuggestedVolumeWithQuery:(NSString *)query {
    
    NSDictionary *params = @{@"api_key" : APIKEY,
                             @"format" : format,
                             @"field_list" : @"name",
                             @"limit" : @10,
                             @"page" : @1,
                             @"query" : query,
                             @"resources" : @"volume"
                             };
    
    return [self GET:@"search"
          parameters:params
         resultClass:[Volume class]];
    
}

-(RACSignal *)fetchVolumesWithQuery:(NSString *)query page:(NSUInteger)page {
    
    NSDictionary *params = @{@"api_key" : APIKEY,
                             @"format" : format,
                             @"field_list" : @"id,image,name,publisher",
                             @"limit" : @20,
                             @"page" : @(page),
                             @"query" : query,
                             @"resources" : @"volume"
                             };
    
    return [self GET:@"search"
          parameters:params
         resultClass:Nil];
}

-(RACSignal *)fetchVolumeDetailWithIdentifier:(NSString *) volumeIdentifier {
    
    
    NSDictionary *params = @{@"api_key" : APIKEY,
                             @"format" : format,
                             @"field_list" : @"characters"
                             };

    NSString *path = [NSString stringWithFormat:@"volume/4050-%@", volumeIdentifier];
    
    return [self GET:path
          parameters:params
         resultClass:Nil];
    
    
}

-(RACSignal *)fetchCharactersWithIdentifiers:(NSArray *) charactersIdentifiers {
    
    NSString * identifiers = [[charactersIdentifiers valueForKey:@"description"] componentsJoinedByString:@"|"];
    NSString *filter = [NSString stringWithFormat:@"id:%@", identifiers];
    
    NSDictionary *params = @{@"api_key" : APIKEY,
                             @"format" : format,
                             @"field_list" : @"name,image",
                             @"filter" : filter
                             };
    
    return [self GET:@"characters"
          parameters:params
         resultClass:[Character class]];
}

#pragma mark - Private

-(RACSignal *)GET:(NSString *) path
       parameters: (NSDictionary *) params
      resultClass:(Class)resultClass {
    
    return [[self GET:path
          parameters:params] map:^id(NSDictionary *JSONDictionary) {
        
        return [Response responseWithJSONDictionary:JSONDictionary
                                        resultClass:resultClass];
    }];
    
}

- (RACSignal *)GET: (NSString *) path
        parameters: (NSDictionary *) params {
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        AFHTTPRequestOperation *operation = [self.requestManager GET:path
                                                          parameters:params
                                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                 
                                                                 [subscriber sendNext:responseObject];
                                                                 [subscriber sendCompleted];
                                                                 
                                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                 
                                                                 [subscriber sendError:error];
                                                                 
                                                             }];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
        
    }] deliverOn:[RACScheduler scheduler]];
    
}

@end
