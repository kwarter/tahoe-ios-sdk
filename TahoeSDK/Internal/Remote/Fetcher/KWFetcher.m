//
//  KWFetcher.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 06/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWFetcher.h"
#import "KWPipelineObject.h"
#import "KWBaseAuthClient.h"

@implementation KWFetcher

- (BOOL)processInput:(KWPipelineObject *)inputObject error:(NSError **)errorPtr {
    
    NSURLRequest *urlRequest = inputObject.currentInput;
    NSAssert([urlRequest isKindOfClass:[NSURLRequest class]], @"invalid input type %@", NSStringFromClass([urlRequest class]));
    
    AFHTTPRequestOperation *operation = [[KWBaseAuthClient sharedClient] HTTPRequestOperationWithRequest:urlRequest
                                                                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Always returns a list of objects
        NSArray *responseObjects = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            // New web services will have a "results" and "error" keys
            id results = [responseObject objectForKey:@"results"];
            if (results) {
                if ([results isKindOfClass:[NSDictionary class]]) {
                    responseObjects = @[results];
                } else if ([results isKindOfClass:[NSArray class]]) {
                    responseObjects = results;
                }
            // Compatibility for legacy web services
            } else {
                responseObjects = @[responseObject];
            }
            
        } else if ([responseObject isKindOfClass:[NSArray class]]) {
            responseObjects = responseObject;
        }
        
        [inputObject continueWithInput:responseObjects andError:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [inputObject continueWithInput:nil andError:error];
    }];
    [[KWBaseAuthClient sharedClient] enqueueHTTPRequestOperation:operation];
    
    return YES;
}

@end
