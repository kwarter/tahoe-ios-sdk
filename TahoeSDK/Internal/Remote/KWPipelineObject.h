//
//  KWPipelineResult.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KWPipeline.h"

@interface KWPipelineObject : NSObject

@property (copy) KWPipelineCompletionBlock completionBlock;
@property (strong) id initialInput;
@property (strong) id currentInput;
@property (assign) NSInteger stageIndex;
@property (strong) NSString *mapperName;
@property (strong) KWPipeline *pipeline;
@property (strong) NSError *currentError;
@property (strong) NSDictionary *userInfo;

- (void)startWithCompletionBlock:(KWPipelineCompletionBlock)handler;
- (void)continueWithInput:(id)newInput andError:(NSError *)error;

@end
