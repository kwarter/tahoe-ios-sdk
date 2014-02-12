//
//  KWMapperWorker.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWMappedResource.h"

/**
 * Synchronous mapper worker providing the base logic for all the mapper workers.
 */
@interface KWMapperWorker : NSObject

@property (strong) NSDictionary *decodedFields;

- (KWMappedResource *)mappedResourceError:(NSError **)errorPtr;

+ (KWMappedResource *)emptyResourceForEntity:(NSString *)entityName withIdentifier:(NSString *)identifier;

+ (KWMapperWorker *)mapperWorkerForModelName:(NSString *)mapperName fields:(NSDictionary *)fields;

@end
