//
//  KWChannelService.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWChannelService.h"
#import "KWDocumentManager.h"
#import "KWMessageClient.h"
#import "KWQuestion.h"

@interface KWChannelService ()

@property (nonatomic, strong) id<KWChannelServiceDelegate> delegate;
@property (nonatomic, strong) NSDate *lastMessageTimestamp;
@property (nonatomic, assign) BOOL isFirstFetch;
@property (nonatomic, assign) BOOL isSubscribed;

@end

@implementation KWChannelService

- (id)initWithChannelIdentifier:(NSString *)identifier delegate:(id<KWChannelServiceDelegate>)delegate {
    self = [super init];
    if (self) {
        _channelIdentifier = identifier;
        _delegate = delegate;
        _isFirstFetch = YES;
    }
    return self;
}

- (void)subscribe {
    
    if (self.isSubscribed) {
        return;
    }
    
    self.isSubscribed = YES;
    
    [self _fetch];
}

- (void)unsubscribe {
    self.isSubscribed = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)_fetch {
    KWChannelService *weakSelf = self;
    
    KWMessageClient *messageClient = [[KWMessageClient alloc] init];
    [messageClient getMessagesForChannelIdentifier:self.channelIdentifier since:self.lastMessageTimestamp limit:10 completion:^(NSArray *messages, NSError *error) {
        
        if (!weakSelf.isSubscribed) {
            return;
        }
        
        if (!error && messages) {
            KWMessage *lastMessage = [messages lastObject];
            if (lastMessage) {
                weakSelf.lastMessageTimestamp = lastMessage.timestamp;
            }
            
            if (weakSelf.isFirstFetch) {
                weakSelf.isFirstFetch = NO;
                if ([weakSelf.delegate respondsToSelector:@selector(channelService:didReceiveHistory:)]) {
                    NSLog(@"[TahoeSDK ChannelService] didReceiveHistory: %i messages", [messages count]);
                    [weakSelf.delegate channelService:weakSelf didReceiveHistory:messages];
                }
            } else {
                [messages enumerateObjectsUsingBlock:^(KWMessage *message, NSUInteger idx, BOOL *stop) {
                    if ([weakSelf.delegate respondsToSelector:@selector(channelService:didReceiveMessage:)]) {
                        NSLog(@"[TahoeSDK ChannelService] didReceiveMessage: %@", message.timestamp);
                        [weakSelf.delegate channelService:weakSelf didReceiveMessage:message];
                    }
                }];
            }
        } else {
            if ([weakSelf.delegate respondsToSelector:@selector(channelService:didReceiveError:)]) {
                NSLog(@"[TahoeSDK ChannelService] didReceiveError: %@", error);
                [weakSelf.delegate channelService:weakSelf didReceiveError:error];
            }
        }
        
        // polling sleep
        [weakSelf performSelector:@selector(_fetch) withObject:nil afterDelay:2];
    }];
}

@end
