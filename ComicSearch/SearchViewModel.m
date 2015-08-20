//
//  SearchViewModel.m
//  ComicSearch
//
//  Created by Yago de la Fuente on 17/5/15.
//  Copyright (c) 2015 cinnika. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchResultViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ComicVineClient.h"
#import "ManagedVolume.h"
#import "Response.h"
#import <Groot/Groot.h>

@interface SearchViewModel () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) ComicVineClient *client;
@property (nonatomic) NSUInteger currentPage;

@property (strong, nonatomic) GRTManagedStore *store;
@property (strong, nonatomic) NSManagedObjectContext *privateContext;
@property (strong, nonatomic) NSManagedObjectContext *mainContext;

@property (strong, nonatomic) NSFetchedResultsController *frc;

@property (strong, nonatomic) RACSubject *didUpdateContentsSubject;

@end

@implementation SearchViewModel

-(instancetype)init {
    
    if (self = [super init]) {
        _client = [ComicVineClient new];
        _currentPage = 1;
        
        _store = [GRTManagedStore temporaryManagedStore];
        
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainContext.persistentStoreCoordinator = _store.persistentStoreCoordinator;
        
        _privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateContext.persistentStoreCoordinator = _store.persistentStoreCoordinator;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self
               selector:@selector(privateContextDidSave:) name:NSManagedObjectContextDidSaveNotification
                 object:_privateContext];
        
        _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:[ManagedVolume fetchRequestForAllVolumes]
                                                   managedObjectContext:_mainContext
                                                     sectionNameKeyPath:nil
                                                              cacheName:nil];
        
        _frc.delegate = self;
        
        [_frc performFetch:nil];
        
//        _didUpdateResults = [self rac_signalForSelector:@selector(controllerDidChangeContent:)];
        
        _didUpdateContentsSubject = [RACSubject subject];
        
    }
    
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setQuery:(NSString *)query {
    
    if (![_query isEqualToString:query]) {
        _query = [query copy];
        [self beginNewSearch];
    }
}

-(RACSignal *)didUpdateResults {
    
    return self.didUpdateContentsSubject;
    
}

-(NSUInteger)numberOfResults {
    
    id<NSFetchedResultsSectionInfo> sectionInfo = self.frc.sections[0];
    
    return [sectionInfo numberOfObjects];
}

- (SearchResultViewModel *)resultAtIndex:(NSUInteger)index {
    
    ManagedVolume *volume = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                          inSection:0]];
    
    return [[SearchResultViewModel alloc] initWithImageURL:[NSURL URLWithString:volume.imageURL]
                                                     title:volume.title
                                                 publisher:volume.publisher
                                                identifier:[volume.identifier stringValue]];
    
}

-(void) fetchMoreResults {
    
    NSManagedObjectContext *context = self.privateContext;
    
    [[self.client fetchVolumesWithQuery:self.query
                                  page:self.currentPage++] doNext:^(Response *response) {
        // Save data
        [GRTJSONSerialization insertObjectsForEntityName:@"Volume"
                                           fromJSONArray:response.results
                                  inManagedObjectContext:context
                                                   error:nil];
        [context performBlockAndWait:^{
            [context save:nil];
        }];
        
    }];
}

#pragma mark - NSFetchedResultsControllerDelegate

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.didUpdateContentsSubject sendNext:nil];
}

#pragma mark - Private

-(RACSignal *) fetchNextPage {
    
    
    NSManagedObjectContext *context = self.privateContext;
    
    return [[[self.client fetchVolumesWithQuery:self.query
                                           page:self.currentPage++] doNext:^(Response *response) {
        // Save data
        [GRTJSONSerialization insertObjectsForEntityName:@"Volume"
                                           fromJSONArray:response.results
                                  inManagedObjectContext:context
                                                   error:nil];
        [context performBlockAndWait:^{
            [context save:nil];
        }];
        
    }] deliverOnMainThread];
}

-(void) beginNewSearch {
    
    self.currentPage = 1;
    
    NSManagedObjectContext *context = self.privateContext;
    
    [self.privateContext performBlock:^{
        
        [ManagedVolume deleteAllVolumesInManagedObjectContext:context];
        [context save:nil];
    }];
    
    [[[self fetchNextPage] publish] connect];
}

-(void)privateContextDidSave: (NSNotification *) notification {
    
    NSManagedObjectContext *context = self.mainContext;
    
    [context performBlock:^{
        [context mergeChangesFromContextDidSaveNotification:notification];
    }];
}

@end
