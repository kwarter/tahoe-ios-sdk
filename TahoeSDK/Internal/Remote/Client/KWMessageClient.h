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

- (void)answerQuestion:(KWQuestion *)question reply:(NSString *)reply data:(NSDictionary *)data completion:(void(^)(NSError *error))block;

- (void)getRepliesForQuestion:(KWQuestion *)question completion:(void(^)(NSArray *replies, NSError *error))block;

- (void)triggerQuestionWithTitle:(NSString *)title choices:(NSArray *)choices data:(NSDictionary *)data channel:(NSString *)channel completion:(void(^)(NSError *error))block;

@end
