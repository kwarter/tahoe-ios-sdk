//
//  KWMergerWorker.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KWManagedObjectCache, KWMappedResource;

typedef enum {
    KWMergerNoMatchingLocalEntityError = 1
} KWMergerErrorCode;

@interface KWMergerWorker : NSObject;

@property (strong) KWMappedResource *mappedResource;
@property (strong) NSManagedObjectContext *managedObjectContext;
@property (strong) NSString *cacheKey;
@property (strong) KWManagedObjectCache *objectCache;

+ (KWMergerWorker *)workerForMappedResource:(KWMappedResource *)mappedResource;
- (NSManagedObject *)managedObjectCreated:(BOOL *)created error:(NSError **)errorPtr;

@end
