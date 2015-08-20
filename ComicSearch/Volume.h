//
//  Volume.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 16/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Volume : MTLModel<MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *title;

@end
