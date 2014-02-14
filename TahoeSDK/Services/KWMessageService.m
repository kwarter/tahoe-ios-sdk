//
//  KWMessageService.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWMessageService.h"
#import "KWMessageClient.h"

@implementation KWMessageService

- (void)answerQuestion:(KWQuestion *)question reply:(NSString *)reply data:(NSDictionary *)data completion:(void(^)(NSError *error))block {
    KWMessageClient *messageClient = [[KWMessageClient alloc] init];
    [messageClient answerQuestion:question reply:reply data:data completion:^(NSError *error) {
        if (block) {
            NSLog(@"[TahoeSDK MessageService] didAnswerQuestion: %@", question.title);
            block(error);
        }
    }];
}

- (void)getRepliesForQuestion:(KWQuestion *)question completion:(void(^)(NSArray *replies, NSError *error))block {
    KWMessageClient *messageClient = [[KWMessageClient alloc] init];
    [messageClient getRepliesForQuestion:question completion:^(NSArray *replies, NSError *error) {
        if (block) {
            NSLog(@"[TahoeSDK MessageService] getRepliesForQuestion: %@", question.title);
            block(replies, error);
        }
    }];
}

@end
