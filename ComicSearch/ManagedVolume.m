//
//  ManagedVolume.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 17/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import "ManagedVolume.h"


@implementation ManagedVolume

@dynamic title;
@dynamic publisher;
@dynamic identifier;
@dynamic imageURL;
@dynamic insertionDate;


-(void)awakeFromInsert {
    [super awakeFromInsert];
    self.insertionDate = [NSDate date];
}

+(NSFetchRequest *)fetchRequestForAllVolumes {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Volume"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"insertionDate"
                                                                     ascending:YES];
    
    fetchRequest.sortDescriptors = @[sortDescriptor];
    fetchRequest.fetchBatchSize = 20;
    
    return fetchRequest;
}

+(void)deleteAllVolumesInManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *fetchRequest = [self fetchRequestForAllVolumes];
    
    fetchRequest.includesPropertyValues = NO;
    
    NSArray *volumes = [context executeFetchRequest:fetchRequest
                                              error:nil];
    
    for (NSManagedObject *volume in volumes) {
        [context deleteObject:volume];
    }
}

@end
