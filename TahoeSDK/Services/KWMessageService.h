//
//  KWMessageService.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWQuestion.h"

@interface KWMessageService : NSObject

/**
 * Answer a question with the user reply and some additional data.
 * @param question The question to answer, this is mandatory.
 * @param reply The user reply for this question, this is mandatory.
 * @param data Additional data that can be added to the answer, this is optional.
 * @param block The completion block that will be called asynchrenously.
 */
- (void)answerQuestion:(KWQuestion *)question reply:(NSString *)reply data:(NSDictionary *)data completion:(void(^)(NSError *error))block;

/**
 * Get the list of replies for a specific message.
 */
- (void)getRepliesForQuestion:(KWQuestion *)question completion:(void(^)(NSArray *replies, NSError *error))block;

@end
