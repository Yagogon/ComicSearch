//
//  Character.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 20/8/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Character : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *imageURL;


@end
