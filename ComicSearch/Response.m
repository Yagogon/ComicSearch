//
//  Response.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 16/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import "Response.h"

@interface Response ()

@property (strong, nonatomic) id results;

@end

@implementation Response

+(instancetype)responseWithJSONDictionary:(NSDictionary *)JSONDictionary resultClass:(Class)resultClass {
    

    Response *response = [MTLJSONAdapter modelOfClass:self
              fromJSONDictionary:JSONDictionary
                           error:NULL];
    
    id results = JSONDictionary[@"results"];
    
    
    if (resultClass != Nil) {
        
        if ([results isKindOfClass:[NSArray class]]) {
            
            response.results = [MTLJSONAdapter modelsOfClass:resultClass
                                               fromJSONArray:results
                                                       error:NULL];
        } else {
            
            response.results = [MTLJSONAdapter modelOfClass:resultClass
                                         fromJSONDictionary:results
                                                      error:NULL];
        }
    } else {
        
        response.results = results;
    }
    
    return response;
}

-(NSError *)error {

    if (self.statusCode.integerValue == 1) {
        return nil;
    }
    
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : self.errorMessage
                               };
    
    return [NSError errorWithDomain:@"ComicVineErrorDomain"
                               code:self.statusCode.integerValue
                           userInfo:userInfo];
}

#pragma mark - MTLJSONSerializing

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"statusCode" : @"status_code",
             @"errorMessage" : @"error",
             @"numberOfTotalResults" : @"number_of_total_results",
             @"offset" : @"offset"
             };
}

@end
