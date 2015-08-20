//
//  SearchResultViewModel.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 17/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchResultViewModel : NSObject

@property (copy, nonatomic, readonly) NSURL *imageURL;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *publisher;
@property (copy, nonatomic, readonly) NSString *identifier;

-(instancetype)initWithImageURL:(NSURL *) imageURL
                          title:(NSString *) title
                      publisher: (NSString *) publisher
                     identifier: (NSString *) identifier;

@end
