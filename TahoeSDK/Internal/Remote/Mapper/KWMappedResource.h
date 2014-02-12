//
//  KWMapperResult.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 6/18/13.
//  Copyright (c) 2013 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWMappedResource : NSObject

@property (nonatomic, strong) NSString *entity;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDictionary *fields;
@property (nonatomic, strong) NSDictionary *relations;

@end
