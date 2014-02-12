//
//  KWEntityCache.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KWMappedResource;

@interface KWManagedObjectCache : NSObject {
    NSMutableDictionary *cache;
}

- (NSManagedObjectID *)managedObjectIdForCacheKey:(NSString *)cacheKey;
- (void)setManagedObjectID:(NSManagedObjectID *)objectID forCacheKey:(NSString *)cacheKey;
- (NSString *)cacheKeyForMappedResource:(KWMappedResource *)mappedResource;

@end
