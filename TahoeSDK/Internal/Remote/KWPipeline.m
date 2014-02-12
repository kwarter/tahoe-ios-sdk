//
//  KWPipeline.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWPipeline.h"
#import "KWPipelineStage.h"
#import "KWPipelineObject.h"

@implementation KWPipeline

@synthesize components;

- (NSArray *)components {
    if (!components) {
        [self loadPipeline];
        NSAssert(components != nil, @"we should have a non nil pipeline after loadPipeline has been called");
    }
    return components;
}

- (void)loadPipeline {
    self.components = [NSArray array];
}

- (void)process:(id)item mapperName:(NSString *)mapperName completionBlock:(KWPipelineCompletionBlock)block {
    KWPipelineObject *pipelineObject = [[KWPipelineObject alloc] init];
    pipelineObject.initialInput = item;
    pipelineObject.mapperName = mapperName;
    pipelineObject.pipeline = self;
    [pipelineObject startWithCompletionBlock:block];
}

- (KWPipelineStage *)stageAtIndex:(NSUInteger)stageIndex {
    return [self.components objectAtIndex:stageIndex];
}

@end
