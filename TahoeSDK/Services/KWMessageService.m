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

- (void)answerQuestion:(KWQuestion *)question withChoice:(NSString *)choice completion:(void(^)(NSError *error))block {
    KWMessageClient *messageClient = [[KWMessageClient alloc] init];
    [messageClient answerQuestion:question withChoice:choice completion:^(NSError *error) {
        if (block) {
            NSLog(@"[TahoeSDK MessageService] didAnswerQuestion: %@", question.title);
            block(error);
        }
    }];
}

@end
