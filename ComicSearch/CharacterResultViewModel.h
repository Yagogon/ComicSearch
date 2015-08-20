//
//  CharacterResultViewModel.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 20/8/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharacterResultViewModel : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSURL *imageURL;

-(id) initWithName: (NSString *) name imageURL: (NSString *) imageURL;

@end
