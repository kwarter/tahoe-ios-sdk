//
//  KWMessageClient.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWBaseCoreDataClient.h"
#import "KWQuestion.h"

@interface KWMessageClient : KWBaseCoreDataClient

- (void)getMessagesForChannelIdentifier:(NSString *)identifier since:(NSDate *)timestamp limit:(NSUInteger)count completion:(void(^)(NSArray *messages, NSError *error))block;

- (void)answerQuestion:(KWQuestion *)question withReply:(NSString *)reply completion:(void(^)(NSError *error))block;

@end
