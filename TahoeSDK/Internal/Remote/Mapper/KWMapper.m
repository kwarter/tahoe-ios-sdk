//
//  KWDecoder.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWMapper.h"
#import "KWMapperWorker.h"
#import "KWMixedMapperWorker.h"
#import "KWPipelineObject.h"

@implementation KWMapper

+ (dispatch_queue_t)queue  {
    static dispatch_queue_t queue = nil;
    if (!queue) {
        queue = dispatch_queue_create("KWMapper", NULL);
    }
    return queue;
}

- (BOOL)processInput:(KWPipelineObject *)inputObject error:(NSError **)errorPtr {
    
    NSArray *decodedResources = inputObject.currentInput;
    NSAssert([decodedResources isKindOfClass:[NSArray class]], @"invalid input type %@", NSStringFromClass([decodedResources class]));
    
    dispatch_queue_t currentQueue = dispatch_get_main_queue();
    dispatch_queue_t workingQueue = [[self class] queue];
    
    dispatch_async(workingQueue, ^{
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:decodedResources.count];
        NSError *error = nil;
        for (NSDictionary *resourceFields in decodedResources) {
            
            id worker = [KWMapperWorker mapperWorkerForModelName:inputObject.mapperName fields:resourceFields];
            NSError *mappingError = nil;
            id entity = nil;
            if ([worker isKindOfClass:[KWMixedMapperWorker class]]) {
                KWMixedMapperWorker *mixedMapperWorker = worker;
                entity = [mixedMapperWorker mappedResourceListError:&mappingError];
            } else if ([worker isKindOfClass:[KWMapperWorker class]]){
                KWMapperWorker *mapperWorker = worker;
                entity = [mapperWorker mappedResourceError:&mappingError];
            }
            
            if (entity) {
                if([entity isKindOfClass:[KWMappedResource class]]) {
                    [results addObject:entity];
                } else if ([entity isKindOfClass:[NSArray class]]) {
                    [results addObjectsFromArray:entity];
                }
            } else {
                if (mappingError) {
                    NSLog(@"mapping error %@", mappingError);
                    //aborting
                    error = mappingError;
                    results = nil;
                    break;
                }
            }
        }
        
        dispatch_async(currentQueue, ^{
            [inputObject continueWithInput:results andError:error];
        });
    });
    return YES;
}

@end
