//
//  KWPipelineComponent.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWPipelineStage.h"

@class KWPipelineObject;

@implementation KWPipelineStage

- (BOOL)processInput:(KWPipelineObject *)inputObject error:(NSError **)errorPtr {
    return NO;
}

@end
