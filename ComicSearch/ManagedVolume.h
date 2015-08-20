//
//  ManagedVolume.h
//  ComicSearch
//
//  Created by Yago de la Fuente on 17/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ManagedVolume : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * publisher;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSDate * insertionDate;

+(NSFetchRequest *) fetchRequestForAllVolumes;

+(void) deleteAllVolumesInManagedObjectContext: (NSManagedObjectContext *) context;


@end
