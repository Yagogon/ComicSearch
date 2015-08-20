//
//  Character.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 20/8/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import "Character.h"

@implementation Character

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"name" : @"name",
             @"imageURL" : @"image"
             };
}

+ (NSValueTransformer *)imageURLJSONTransformer {
   
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *images, BOOL *success, NSError *__autoreleasing *error) {
        return images[@"icon_url"];
    }];
}

@end
