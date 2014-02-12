//
//  KWMapperWorker.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWMapperWorker.h"
#import "KWMapperRegistry.h"
#import "KWPassThroughMapperWorker.h"

@interface KWMapperWorker ()  {
    NSDictionary *decodedFields;
}

@end

@implementation KWMapperWorker

@synthesize decodedFields;

+ (KWMapperWorker *)mapperWorkerForModelName:(NSString *)mapperName fields:(NSDictionary *)fields {
    Class workerClass = [[KWMapperRegistry sharedRegistry] workerClassForMapperName:mapperName];
    
    if (!workerClass) {
        workerClass = [KWPassThroughMapperWorker class];
    }

    KWMapperWorker *worker = [[workerClass alloc] init];
    worker.decodedFields = fields;
    
    return worker;
}

- (KWMappedResource *)mappedResourceError:(NSError **)errorPtr {
    return nil;
}

+ (KWMappedResource *)emptyResourceForEntity:(NSString *)entityName withIdentifier:(NSString *)identifier {
    KWMappedResource *mappedResource = [[KWMappedResource alloc] init];
    mappedResource.entity = entityName;
    mappedResource.identifier = identifier;
    mappedResource.fields = @{@"identifier": identifier};
    return mappedResource;
}

@end
