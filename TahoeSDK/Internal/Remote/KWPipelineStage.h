//
//  KWPipelineComponent.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWPipelineObject;

@interface KWPipelineStage : NSObject

- (BOOL)processInput:(KWPipelineObject *)inputObject error:(NSError **)errorPtr;

@end
