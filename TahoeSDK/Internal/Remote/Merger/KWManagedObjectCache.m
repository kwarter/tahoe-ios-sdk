//
//  KWEntityCache.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWManagedObjectCache.h"
#import "KWMappedResource.h"

@interface KWManagedObjectCache()
@property (nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation KWManagedObjectCache

@synthesize cache;

- (id)init {
    self = [super init];
    if (self) {
        //TODO: register to low memory notifications to clear the cache
    }
    return self;
}

- (NSMutableDictionary *)cache {
    if (!cache) {
        self.cache = [NSMutableDictionary dictionary];
    }
    return cache;
}

- (NSManagedObjectID *)managedObjectIdForCacheKey:(NSString *)cacheKey {
	return [cache objectForKey:cacheKey];
}

- (void)setManagedObjectID:(NSManagedObjectID *)objectID forCacheKey:(NSString *)cacheKey {
    [self.cache setObject:objectID forKey:cacheKey];
}

- (NSString *)cacheKeyForMappedResource:(KWMappedResource *)mappedResource {
    return [NSString stringWithFormat:@"%@:%@", mappedResource.entity, mappedResource.identifier];
}

@end
