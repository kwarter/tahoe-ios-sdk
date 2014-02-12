//
//  KWChannelServiceDelegate.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWChannelService, KWMessage;

@protocol KWChannelServiceDelegate <NSObject>

- (void)channelService:(KWChannelService *)service didReceiveHistory:(NSArray *)messages;
- (void)channelService:(KWChannelService *)service didReceiveMessage:(KWMessage *)message;

- (void)channelService:(KWChannelService *)service didReceiveError:(NSError *)error;

@end
