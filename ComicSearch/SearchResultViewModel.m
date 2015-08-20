//
//  SearchResultViewModel.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 17/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//


#import "SearchResultViewModel.h"

@implementation SearchResultViewModel

-(instancetype)initWithImageURL:(NSURL *)imageURL
                          title:(NSString *)title
                      publisher:(NSString *)publisher
                     identifier:(NSString *)identifier{
    
    if (self = [super init]) {
        _imageURL = [imageURL copy];
        _title = [title copy];
        _publisher = [publisher copy];
        _identifier = [identifier copy];
    }
    
    return self;
}

@end
