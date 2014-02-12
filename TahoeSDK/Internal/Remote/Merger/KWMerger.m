//
//  KWMerger.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWMerger.h"
#import "KWPipelineObject.h"
#import "KWManagedObjectCache.h"
#import "KWMergerWorker.h"
#import "KWMappedResource.h"

@interface KWMerger()
@property (strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation KWMerger

@synthesize managedObjectContext;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc {
    self = [super init];
    if (self) {
        self.managedObjectContext = moc;
    }
    return self;
}

+ (dispatch_queue_t)queue  {
    static dispatch_queue_t queue = nil;
    if (!queue) {
        queue = dispatch_queue_create("KWMerger", NULL);
    }
    return queue;
}

- (BOOL)processInput:(KWPipelineObject *)inputObject error:(NSError **)errorPtr {
    
    dispatch_queue_t currentQueue = dispatch_get_main_queue();
    dispatch_queue_t workingQueue = [[self class] queue];
    
    NSArray *resources = inputObject.currentInput;
    NSAssert([resources isKindOfClass:[NSArray class]], @"invalid input type %@", NSStringFromClass([resources class]));
    
    NSPersistentStoreCoordinator *psc = [self.managedObjectContext persistentStoreCoordinator];
    id mergePolicy = [self.managedObjectContext mergePolicy];
    dispatch_async(workingQueue, ^{
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:resources.count];
        NSError *error = nil;
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
        [moc setPersistentStoreCoordinator:psc];
        [moc setMergePolicy:mergePolicy];
        KWManagedObjectCache *cache = [[KWManagedObjectCache alloc] init];
        
        //1- warm up the cache
		NSMutableDictionary *fetchedPropertiesByEntityName = [NSMutableDictionary dictionary];
        for (KWMappedResource *mappedResource in resources) {
            NSString *entityName = mappedResource.entity;
			NSMutableDictionary *fetchedProperties = [fetchedPropertiesByEntityName objectForKey:entityName];
			if (!fetchedProperties) {
				fetchedProperties = [NSMutableDictionary dictionary];
				[fetchedPropertiesByEntityName setObject:fetchedProperties forKey:entityName];
			}
			
            NSString *key = @"identifier";
            NSMutableSet *values = [fetchedProperties objectForKey:key];
            if (!values) {
                values = [NSMutableSet set];
                [fetchedProperties setObject:values forKey:key];
            }
            [values addObject:mappedResource.identifier];
        }
		
		for (NSString *entityName in [fetchedPropertiesByEntityName allKeys]) {
			NSDictionary *fetchedProperties = [fetchedPropertiesByEntityName objectForKey:entityName];
			if ([fetchedProperties count] == 1) {
				//execute a fetch request
				NSString *keyPath = [[fetchedProperties allKeys] lastObject];
				NSFetchRequest *request = [[NSFetchRequest alloc] init];
                NSEntityDescription *entityDescr = [NSEntityDescription entityForName:entityName
                                                               inManagedObjectContext:moc];
                if (!entityDescr) {
                    continue;
                }
				[request setEntity:entityDescr];
                
				NSString *predicateFmt = [NSString stringWithFormat:@"%@ IN %%@", keyPath];
				NSArray *values = [[fetchedProperties objectForKey:keyPath] allObjects];
				[request setPredicate:[NSPredicate predicateWithFormat:predicateFmt, values]];
				
				//fake the mapped resource to get its cache key
				NSError *warmupFetchError = nil;
				NSArray *result = [moc executeFetchRequest:request error:&warmupFetchError];
				NSAssert(result != nil, @"failed to executeFetchRequest with error %@", [warmupFetchError localizedDescription]);
				
				for (NSManagedObject *mo in result) {
                    KWMappedResource *fakeMappedObject = [[KWMappedResource alloc] init];
                    fakeMappedObject.entity = entityName;
                    fakeMappedObject.identifier = [mo valueForKeyPath:keyPath];
					NSString *cacheKey = [cache cacheKeyForMappedResource:fakeMappedObject];
					
					[cache setManagedObjectID:[mo objectID] forCacheKey:cacheKey];
				}
			}
		}
		
        //2- merge each item
        for (KWMappedResource *mappedResource in resources) {
            KWMergerWorker *worker = [KWMergerWorker workerForMappedResource:mappedResource];
            worker.managedObjectContext = moc;
            worker.objectCache = cache;
            BOOL created = NO;
            NSError *mergeError = nil;
            NSManagedObject *mo = [worker managedObjectCreated:&created error:&mergeError];
            if (mo) {
                [results addObject:mo];
            } else {
                NSLog(@"merge error %@", mergeError);
            }
        }
        
        //3- save the context
        __block NSNotification *didSaveNotification = nil;
        id obs = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:moc queue:nil usingBlock:^(NSNotification *notif) {
            didSaveNotification = [notif copy];
        }];
        if ([moc hasChanges]) {
            NSError *saveError = nil;
            BOOL succeed = [moc save:&saveError];
            NSAssert2(succeed, @"save error:\n%@\n%@", [saveError localizedDescription], [saveError userInfo]);
        }
        NSMutableArray *objectIds = [NSMutableArray arrayWithCapacity:results.count];
        for (NSManagedObject *mo in results) {
            [objectIds addObject:[mo objectID]];
        }
        
        //4- dispatch the response
        dispatch_sync(currentQueue, ^{
            
            [self.managedObjectContext mergeChangesFromContextDidSaveNotification:didSaveNotification];
            NSMutableArray *currentMOCObjects = [NSMutableArray arrayWithCapacity:objectIds.count];
            for (NSManagedObjectID *objectID in objectIds) {
                NSManagedObject *mo = [self.managedObjectContext objectWithID:objectID];
                if (mo) {
                    [currentMOCObjects addObject:mo];
                } else {
                    NSAssert1(NO, @"unable to find object %@", objectID);
                }
            }
            [inputObject continueWithInput:currentMOCObjects andError:error];
            
        });
        
        [[NSNotificationCenter defaultCenter] removeObserver:obs name:NSManagedObjectContextDidSaveNotification object:moc];
    });
    return YES;
}

@end
