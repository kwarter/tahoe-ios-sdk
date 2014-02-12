//
//  KWMapperRegistry.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWMapperRegistrationInfo;

@interface KWMapperRegistry : NSObject

+ (KWMapperRegistry *)sharedRegistry;

- (Class)workerClassForMapperName:(NSString *)mapperName;

@end
