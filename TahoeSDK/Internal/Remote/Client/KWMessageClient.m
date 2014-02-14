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

- (void)answerQuestion:(KWQuestion *)question withReply:(NSString *)reply completion:(void (^)(NSError *))block {
    
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
    
    
    NSDictionary *params = @{
        @"choice": reply
    };
    
    NSString *path = [NSString stringWithFormat:@"/channels/%@/messages/%@/replies/", question.channel.identifier, question.identifier];
    
    [[KWBaseAuthClient sharedClient] postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Set the correct choice id in the game if sent back by the server
        question.userChoice = reply;
        [[KWDocumentManager sharedDocument] save];
        
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
