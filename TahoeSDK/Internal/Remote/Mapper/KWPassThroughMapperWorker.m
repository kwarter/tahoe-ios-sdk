//
//  KWPassThroughMapperWorker.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWPassThroughMapperWorker.h"

@implementation KWPassThroughMapperWorker

- (KWMappedResource *)mappedResourceError:(NSError **)errorPtr {
    NSDictionary *resourceFields = self.decodedFields;
    
    KWMappedResource *mappedResource = [[KWMappedResource alloc] init];
    mappedResource.entity = nil;
    mappedResource.identifier = [resourceFields valueForKey:@"id"];
    mappedResource.fields = resourceFields;
    
    return mappedResource;
}

@end
