//
//  KWQuestionMapperWorker.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWQuestionMapperWorker.h"
#import "KWPassThroughMapperWorker.h"
#import "NSDate+SSToolkitAdditions.h"

@implementation KWQuestionMapperWorker

+ (NSString *)supportedMessageType {
    return @"question";
}

+ (NSString *)supportedModelName {
    return @"Question";
}

- (KWMappedResource *)mappedResourceError:(NSError **)errorPtr {
    NSString *entity = [KWQuestionMapperWorker supportedModelName];
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
    
    if ([resourceFields valueForKeyPath:@"data.choices"]) {
        [fields setValue:[resourceFields valueForKeyPath:@"data.choices"] forKey:@"choices"];
    }
    
    mappedResource.fields = [NSDictionary dictionaryWithDictionary:fields];
    
    NSMutableDictionary *relations = [NSMutableDictionary dictionary];
    
    NSString *channelIdentifier = [resourceFields objectForKey:@"channel_id"];
    if (channelIdentifier) {
        KWMappedResource *channelMappedResource = [KWMapperWorker emptyResourceForEntity:@"Channel" withIdentifier:channelIdentifier];
        [relations setValue:channelMappedResource forKey:@"channel"];
    }
    
    mappedResource.relations = [NSDictionary dictionaryWithDictionary:relations];
    
    return mappedResource;
}

@end
