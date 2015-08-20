//
//  Response.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 16/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Response : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly)  NSNumber *statusCode;
@property (copy, nonatomic, readonly)  NSString *errorMessage;
@property (copy, nonatomic, readonly)  NSNumber *numberOfTotalResults;
@property (copy, nonatomic, readonly)  NSNumber *offset;
@property (strong, nonatomic, readonly) id results;

+(instancetype) responseWithJSONDictionary: (NSDictionary *) JSONDictionary resultClass:(Class) resultClass;

-(NSError *) error;

@end
