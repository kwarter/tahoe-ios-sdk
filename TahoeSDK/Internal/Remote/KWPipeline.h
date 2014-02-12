//
//  KWPipeline.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWPipelineStage;

typedef void (^KWPipelineCompletionBlock)(id result, NSError *error);

@interface KWPipeline : NSObject {
    NSArray *components;
}

@property (nonatomic, strong) NSArray *components;

- (void)loadPipeline;
- (KWPipelineStage *)stageAtIndex:(NSUInteger)stageIndex;
- (void)process:(id)item mapperName:(NSString *)mapperName completionBlock:(KWPipelineCompletionBlock)block;

@end
