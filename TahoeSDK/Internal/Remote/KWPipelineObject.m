//
//  KWPipelineResult.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWPipelineObject.h"
#import "KWPipelineStage.h"
#import "KWNetworkActivityIndicator.h"

@implementation KWPipelineObject

@synthesize pipeline;
@synthesize mapperName;
@synthesize stageIndex;
@synthesize initialInput;
@synthesize completionBlock;
@synthesize currentInput;
@synthesize currentError;
@synthesize userInfo;

- (void)startCurrentStage {
    NSError *error = nil;
    KWPipelineStage *stage = [self.pipeline stageAtIndex:self.stageIndex];
    BOOL status = [stage processInput:self error:&error];
    if (!status) {
        NSLog(@"pipeline error %@", error);
        if (!error) {
            error = [NSError errorWithDomain:@"com.kwarter.PipelineError" code:1 userInfo:nil];
        }
        self.completionBlock(nil, error);
    }
}

- (void)continueWithInput:(id)newInput andError:(NSError *)error {
    self.stageIndex ++;
    self.currentInput = newInput;
    self.currentError = error;
    if (error || self.stageIndex >= self.pipeline.components.count) {
        self.completionBlock(self.currentInput, self.currentError);
        [[KWNetworkActivityIndicator sharedActivityIndicator] popActivity];
    } else {
        [self startCurrentStage];
    }
}

- (void)startWithCompletionBlock:(KWPipelineCompletionBlock)handler {
    [[KWNetworkActivityIndicator sharedActivityIndicator] pushActivity];
    self.completionBlock = handler;
    self.currentInput = self.initialInput;
    [self startCurrentStage];
}

@end
