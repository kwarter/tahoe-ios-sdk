//
//  KWMessageMapperWorker.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWMessageMapperWorker.h"
#import "KWMessageMapperRegistration.h"
#import "NSObject+Registration.h"

static NSDictionary *messageMapperWorkers = NULL;

@implementation KWMessageMapperWorker

+ (void)registerGameWorkers {
    NSMutableDictionary *mapperWorkers = [NSMutableDictionary dictionary];
    for (id class in [NSObject classesConformingTo:@protocol(KWMessageMapperRegistration)]) {
        [mapperWorkers addEntriesFromDictionary:@{
            [class supportedMessageType] : [class supportedModelName]
        }];
    }
    messageMapperWorkers = [NSDictionary dictionaryWithDictionary:mapperWorkers];
}

+ (void)initialize {
    [self registerGameWorkers];
}

+ (NSString *)supportedModelName {
    return @"Message";
}

- (KWMappedResource *)mappedResourceError:(NSError **)errorPtr {
    NSDictionary *resourceFields = self.decodedFields;
    NSString *messageType = [resourceFields valueForKeyPath:@"type"];
    
    NSString *messageModel = [messageMapperWorkers objectForKey:messageType];
    if(!messageModel) {
        // We don't know how to parse this type of game
        return nil;
    }
    
    KWMapperWorker *messageMapperWorker = [KWMapperWorker mapperWorkerForModelName:messageModel fields:resourceFields];
    if(!messageMapperWorker) {
        // We don't know how to parse this type of game
        return nil;
    }
    
    NSError *messageMappingError = nil;
    KWMappedResource *messageMappedResource = [messageMapperWorker mappedResourceError:&messageMappingError];
    if (!messageMappedResource) {
        if (errorPtr != NULL) {
            *errorPtr = messageMappingError;
        }
    }
    
    return messageMappedResource;
}

@end
