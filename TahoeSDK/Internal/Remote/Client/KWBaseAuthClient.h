//
//  KWBaseClient.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 25/11/12.
//  Copyright (c) 2012 Ludovic Landry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

extern NSString *const KWClientErrorDomain;
extern NSString *const KWClientErrorMissingParameterKey;
extern NSInteger const KWClientErrorMissingParameterError;
extern NSString *const KWClientErrorInvalidParameterKey;
extern NSInteger const KWClientErrorInvalidParameterError;
extern NSString *const KWClientErrorNeedsAccessTokenKey;
extern NSInteger const KWClientErrorNeedsAuthenticationTokenError;
extern NSString *const KWClientErrorNeedsUserIdentifierKey;
extern NSInteger const KWClientErrorNeedsUserIdentifierError;
extern NSString *const KWClientErrorNeedsSecretKey;
extern NSInteger const KWClientErrorNeedsSecretError;

@interface KWBaseAuthClient : AFHTTPClient

+ (KWBaseAuthClient *)sharedClient;

@end
