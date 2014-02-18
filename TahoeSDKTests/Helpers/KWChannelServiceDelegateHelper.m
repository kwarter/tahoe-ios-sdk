//
//  KWChannelServiceDelegateHelper.m
//  TahoeSDK
//
//  Created by Elodie Ferrais on 2/17/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWChannelServiceDelegateHelper.h"

@interface KWChannelServiceDelegateHelper ()

@property (nonatomic, copy) void (^historyBlock)(NSArray *history);
@property (nonatomic, copy) void (^messageBlock)(KWMessage *message);
@property (nonatomic, copy) void (^errorBlock)(NSError *error);

@end

@implementation KWChannelServiceDelegateHelper

- (id)initWithHistoryBlock:(void(^)(NSArray *history))historyBlock
              messageBlock:(void(^)(KWMessage *message))messageBlock
                errorBlock:(void(^)(NSError *error))errorBlock {
    self = [super init];
    if (self) {
        _historyBlock = historyBlock;
        _messageBlock = messageBlock;
        _errorBlock = errorBlock;
    }
    return self;
}

- (void)channelService:(KWChannelService *)service didReceiveHistory:(NSArray *)messages {
    if (self.historyBlock) {
        self.historyBlock(messages);
    }
}

- (void)channelService:(KWChannelService *)service didReceiveMessage:(KWMessage *)message {
    if (self.messageBlock) {
        self.messageBlock(message);
    }
}

- (void)channelService:(KWChannelService *)service didReceiveError:(NSError *)error {
    if (self.errorBlock) {
        self.errorBlock(error);
    }
}

@end
