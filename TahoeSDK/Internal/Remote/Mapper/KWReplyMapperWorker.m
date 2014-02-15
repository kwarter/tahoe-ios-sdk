//
//  KWReplyMapperWorker.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWReplyMapperWorker.h"
#import "KWPassThroughMapperWorker.h"
#import "NSDate+SSToolkitAdditions.h"

@implementation KWReplyMapperWorker

+ (NSString *)supportedModelName {
    return @"Reply";
}

- (KWMappedResource *)mappedResourceError:(NSError **)errorPtr {
    NSString *entity = [KWReplyMapperWorker supportedModelName];
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
    
    if ([resourceFields valueForKey:@"timestamp"]) {
        [fields setValue:[NSDate dateFromISO8601String:[resourceFields valueForKey:@"timestamp"]] forKey:@"timestamp"];
    }
    
    if ([resourceFields valueForKey:@"title"]) {
        [fields setValue:[resourceFields valueForKey:@"title"] forKey:@"title"];
    }
    
    NSLog(@">>>> %@", resourceFields);
    
    mappedResource.fields = [NSDictionary dictionaryWithDictionary:fields];
    
    return mappedResource;
}

@end
