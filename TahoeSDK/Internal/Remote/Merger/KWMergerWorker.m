//
//  KWMergerWorker.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWMergerWorker.h"
#import "KWBasicMergerWorker.h"
#import "KWManagedObjectCache.h"
#import "KWMappedResource.h"

@interface KWMergerWorker () {
@private
    dispatch_queue_t queue;
}

@end

@implementation KWMergerWorker

@synthesize mappedResource;
@synthesize managedObjectContext;
@synthesize objectCache;
@synthesize cacheKey;

- (id)init {
    self = [super init];
    if (self) {
        queue = dispatch_queue_create("com.kwarter.KWMergerWorker", NULL);
    }
    return self;
}

- (void) dealloc {
    self.cacheKey = nil;
}

+ (KWMergerWorker *)workerForMappedResource:(KWMappedResource *)mappedResource {
    KWMergerWorker *worker = [[KWBasicMergerWorker alloc] init];
    worker.mappedResource = mappedResource;
    return worker;
}

- (NSManagedObject *)managedObjectCreated:(BOOL *)created error:(NSError **)errorPtr {
    return nil;
}

- (void)setCacheKey:(NSString *)newKey {
    dispatch_sync(queue, ^{
        if (newKey != cacheKey) {
            cacheKey = newKey;
        }
    });
}

- (NSString *)cacheKey {
    __block NSString *value = nil;
    dispatch_sync(queue, ^{
        if (!cacheKey) {
            cacheKey = [self.objectCache cacheKeyForMappedResource:self.mappedResource];
        }
        value = cacheKey;
    });
    return value;
}

@end
