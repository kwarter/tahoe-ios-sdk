//
//  KWMapperResult.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 6/18/13.
//  Copyright (c) 2013 Kwarter, inc. All rights reserved.
//

#import "KWMappedResource.h"

@implementation KWMappedResource

@synthesize entity;
@synthesize identifier;
@synthesize fields;
@synthesize relations;

- (NSString *)description {
    NSDictionary *dictionnaryRepresentation = @{
        @"entity": (self.entity) ? self.entity : [NSNull null],
        @"identifier": (self.identifier) ? self.identifier : [NSNull null],
        @"fields": (self.fields) ? self.fields : [NSNull null],
        @"relations": (self.relations) ? self.relations : [NSNull null]
    };
    return [dictionnaryRepresentation description];
}

@end
