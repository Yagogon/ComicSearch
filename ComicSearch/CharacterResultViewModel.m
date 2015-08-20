//
//  CharacterResultViewModel.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 20/8/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import "CharacterResultViewModel.h"

@implementation CharacterResultViewModel

-(id) initWithName: (NSString *) name imageURL: (NSString *) imageURL {
    
    
    if (self = [super init]) {
        _name = name;
        _imageURL = [NSURL URLWithString:imageURL];
    }
    
    return  self;
}

@end
