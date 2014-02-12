//
//  KWNetworkActivityIndicator.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWNetworkActivityIndicator.h"

@interface KWNetworkActivityIndicator()  {
    NSInteger activityCount;
}

@end

@implementation KWNetworkActivityIndicator

+ (KWNetworkActivityIndicator*)sharedActivityIndicator {
    static id sharedActivityIndicator = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedActivityIndicator = [[self alloc] init];
    });
    
    return sharedActivityIndicator;
}

- (void)pushActivity {
    activityCount ++;
    if (activityCount > 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)popActivity {
    activityCount --;
    if (activityCount <= 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end
