//
//  KWChannelService.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWChannelServiceDelegate.h"

@interface KWChannelService : NSObject

@property (nonatomic, strong) NSString *channelIdentifier;

- (id)initWithChannelIdentifier:(NSString *)identifier delegate:(id<KWChannelServiceDelegate>)delegate;

// Subscribe if you're not already subscribed. Idempotent.
- (void)subscribe;

// Unsubscribe if you are subscribed. Idempotent.
- (void)unsubscribe;

@end
