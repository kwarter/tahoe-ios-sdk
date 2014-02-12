//
//  KWMapperRegistry.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWMapperRegistry.h"
#import "NSObject+Registration.h"
#import "KWMapperRegistration.h"

@interface KWMapperRegistry() {
    NSMutableDictionary *modelNameMapping;
}

- (void)registerMapperWorker:(NSString *)modelName andWorkerClassName:(NSString*)workerClassName;
- (void)registerWorkers;

@end

@implementation KWMapperRegistry

- (id) init {
    self = [super init];
    if (self) {
        modelNameMapping = [[NSMutableDictionary alloc] init];
        [self registerWorkers];
    }
    return self;
}

#pragma mark singleton stuff

static KWMapperRegistry *sharedRegistry = nil;

+ (KWMapperRegistry *)sharedRegistry {
    
	if(sharedRegistry) {
		return sharedRegistry;
	}
	
	@synchronized(self) {
		if (sharedRegistry == nil)
			sharedRegistry = [[self alloc] init];
	}
	return sharedRegistry;
}

+ (id)alloc {
	@synchronized(self) {
		NSAssert(sharedRegistry == nil, @"Attempted to allocate a second instance of a singleton.");
		sharedRegistry = [super alloc];
		return sharedRegistry;
	}
}

+ (id)copy {
	@synchronized(self) {
		NSAssert(sharedRegistry == nil, @"Attempted to copy the singleton.");
		return sharedRegistry;
	}
}

- (Class)workerClassForMapperName:(NSString *)mapperName {
    NSString *workerClassName = [modelNameMapping objectForKey:mapperName];
    if (workerClassName) {
        return NSClassFromString(workerClassName);
    } else {
        return nil;
    }
}

- (void)registerMapperWorker:(NSString *)modelName andWorkerClassName:(NSString*)workerClassName {
    if (workerClassName && modelName) {
        [modelNameMapping setObject:workerClassName forKey:modelName];
    }
}

- (void)registerWorkers {
    for (id class in [NSObject classesConformingTo:@protocol(KWMapperRegistration)]) {
        NSString *className = NSStringFromClass(class);
        
        NSString *mapperName;
        if ([class respondsToSelector:@selector(supportedModelName)]) {
            mapperName = [class supportedModelName];
        }
        
        [self registerMapperWorker:mapperName andWorkerClassName:className];
    }
}

@end
