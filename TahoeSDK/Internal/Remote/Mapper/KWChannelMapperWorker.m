//
//  KWChannelMapperWorker.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWChannelMapperWorker.h"

@implementation KWChannelMapperWorker

+ (NSString *)supportedModelName {
    return @"Channel";
}

- (KWMappedResource *)mappedResourceError:(NSError **)error {
    NSString *entity = [KWChannelMapperWorker supportedModelName];
    NSDictionary *resourceFields = self.decodedFields;
    
    NSString *resourceIdentifier = [resourceFields valueForKey:@"id"];
    if (!resourceIdentifier) {
        return nil;
    }
    KWMappedResource *mappedResource = [[KWMappedResource alloc] init];
    mappedResource.entity = entity;
    mappedResource.identifier = resourceIdentifier;
    
    NSDictionary *fields = [NSMutableDictionary dictionary];
    [fields setValue:[resourceFields valueForKey:@"id"] forKey:@"identifier"];
    [fields setValue:[resourceFields valueForKey:@"title"] forKey:@"title"];
    
    mappedResource.fields = [NSDictionary dictionaryWithDictionary:fields];
    
    return mappedResource;
}

@end
