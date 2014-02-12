//
//  KWMessageMapperRegistration.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWMapperRegistration.h"

@protocol KWMessageMapperRegistration <KWMapperRegistration>

+ (NSString *)supportedMessageType;

@end
