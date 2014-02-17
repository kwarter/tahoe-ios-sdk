//
//  KWMessageClient.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWMessageClient.h"
#import "KWDocumentManager.h"
#import "NSDate+SSToolkitAdditions.h"
#import "KWChannel.h"

@implementation KWMessageClient

- (void)getMessagesForChannelIdentifier:(NSString *)identifier since:(NSDate *)timestamp limit:(NSUInteger)count completion:(void(^)(NSArray *messages, NSError *error))block {
    
    // Validate params
    if (!identifier) {
        if (block) {
            NSDictionary *userInfo = @{KWClientErrorMissingParameterKey: @"identifier"};
            NSError *paramsError = [NSError errorWithDomain:KWClientErrorDomain code:KWClientErrorMissingParameterError userInfo:userInfo];
            block(nil, paramsError);
        }
        return;
    }
    
    NSString *parameters =  (timestamp) ? [NSString stringWithFormat:@"?since=%@", [timestamp ISO8601String]] : @"";
    
    //TODO: limit is not implemented yet!
    
    NSString *path = [NSString stringWithFormat:@"/channels/%@/messages/%@", identifier, parameters];
    
    // Build the operation with the url
    NSURLRequest *urlRequest = [[KWBaseAuthClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:urlRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id result) {
        NSArray *messages = [result valueForKey:@"messages"];
        
        KWBaseCoreDataClient *client = [[KWBaseCoreDataClient alloc] init];
        [client objectsFromJSON:messages modelName:@"Message" completionBlock:^(NSArray *result, NSError *error) {
            if (block) {
                block(result, nil);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) block(nil, error);
    }];
    
    // Start the operation (enqueue in the shared client)
    [[KWBaseAuthClient sharedClient] enqueueHTTPRequestOperation:operation];
}

- (void)answerQuestion:(KWQuestion *)question reply:(NSString *)reply data:(NSDictionary *)data completion:(void (^)(NSError *))block {
    
    // Validate params
    if (!question) {
        if (block) {
            NSDictionary *userInfo = @{KWClientErrorMissingParameterKey: @"question"};
            NSError *paramsError = [NSError errorWithDomain:KWClientErrorDomain code:KWClientErrorMissingParameterError userInfo:userInfo];
            block(paramsError);
        }
        return;
    }
    if (!reply) {
        if (block) {
            NSDictionary *userInfo = @{KWClientErrorMissingParameterKey: @"reply"};
            NSError *paramsError = [NSError errorWithDomain:KWClientErrorDomain code:KWClientErrorMissingParameterError userInfo:userInfo];
            block(paramsError);
        }
        return;
    }
    
    
    // Generate an UUID for the reply
    NSString *replyIdentifier = [[NSUUID UUID] UUIDString];
    
    // Build the parameters
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithObject:reply forKey:@"reply"];
    if (data) {
        [mutableParams setValue:data forKey:@"data"];
    }
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:mutableParams];
    
    NSString *path = [NSString stringWithFormat:@"/channels/%@/messages/%@/replies/%@", question.channel.identifier, question.identifier, replyIdentifier];
    [[KWBaseAuthClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *replies = @[
            @{
                @"id": replyIdentifier,
                @"message_id": question.identifier,
                @"reply": reply,
            }
        ];
        
        KWBaseCoreDataClient *client = [[KWBaseCoreDataClient alloc] init];
        [client objectsFromJSON:replies modelName:@"Reply" completionBlock:^(NSArray *result, NSError *error) {
            
            // Set the correct choice id in the game if sent back by the server
            if (result && !error) {
                question.userReply = [result firstObject];
                [[KWDocumentManager sharedDocument] save];
            }
            
            if (block) {
                block(nil);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}

- (void)getRepliesForQuestion:(KWQuestion *)question completion:(void(^)(NSArray *replies, NSError *error))block {
    
    // Validate params
    if (!question) {
        if (block) {
            NSDictionary *userInfo = @{KWClientErrorMissingParameterKey: @"question"};
            NSError *paramsError = [NSError errorWithDomain:KWClientErrorDomain code:KWClientErrorMissingParameterError userInfo:userInfo];
            block(nil, paramsError);
        }
        return;
    }
    
    
    NSString *path = [NSString stringWithFormat:@"/channels/%@/messages/%@/replies/", question.channel.identifier, question.identifier];
    
    [[KWBaseAuthClient sharedClient] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *result) {
        NSArray *replies = [result valueForKey:@"replies"];
        
        KWBaseCoreDataClient *client = [[KWBaseCoreDataClient alloc] init];
        [client objectsFromJSON:replies modelName:@"Reply" completionBlock:^(NSArray *result, NSError *error) {
            if (block) {
                block(result, nil);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)triggerQuestionWithTitle:(NSString *)title choices:(NSArray *)choices data:(NSDictionary *)data channel:(NSString *)channel completion:(void(^)(NSError *error))block {
    
    // Validate params
    if (!title) {
        if (block) {
            NSDictionary *userInfo = @{KWClientErrorMissingParameterKey: @"title"};
            NSError *paramsError = [NSError errorWithDomain:KWClientErrorDomain code:KWClientErrorMissingParameterError userInfo:userInfo];
            block(paramsError);
        }
        return;
    }
    if (!choices) {
        if (block) {
            NSDictionary *userInfo = @{KWClientErrorMissingParameterKey: @"choices"};
            NSError *paramsError = [NSError errorWithDomain:KWClientErrorDomain code:KWClientErrorMissingParameterError userInfo:userInfo];
            block(paramsError);
        }
        return;
    }
    if (!channel) {
        if (block) {
            NSDictionary *userInfo = @{KWClientErrorMissingParameterKey: @"channel"};
            NSError *paramsError = [NSError errorWithDomain:KWClientErrorDomain code:KWClientErrorMissingParameterError userInfo:userInfo];
            block(paramsError);
        }
        return;
    }
    
    
    // Generate an UUID for the question
    NSString *questionIdentifier = [[NSUUID UUID] UUIDString];
    
    // Build the parameters
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:title, @"title",
                                                                                           choices, @"choices",
                                                                                           @"question", @"type",
                                                                                           nil];
    if (data) {
        [mutableParams setValue:data forKey:@"data"];
    }
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:mutableParams];
    
    NSString *path = [NSString stringWithFormat:@"/channels/%@/messages/%@", channel, questionIdentifier];
    [[KWBaseAuthClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (block) {
            block(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(error);
        }
    }];
}

@end
