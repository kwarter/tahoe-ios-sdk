//
//  KWCredentialManager.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 25/11/12.
//  Copyright (c) 2012 Ludovic Landry. All rights reserved.
//

#import "KWCredentialManager.h"

#define SERVICE_NAME        @"KwarterSDK-AuthClient"
#define ACCESS_TOKEN_KEY    @"access_token"
#define USER_ID_KEY         @"user_identifier"

@implementation KWCredentialManager

+ (KWCredentialManager *)sharedManager {
    static KWCredentialManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)clearSavedCredentials {
    [self setAccessToken:nil];
    [self setUserIdentifier:nil];
}

- (NSString *)accessToken {
    return [self secureValueForKey:ACCESS_TOKEN_KEY];
}

- (void)setAccessToken:(NSString *)accessToken {
    [self setSecureValue:accessToken forKey:ACCESS_TOKEN_KEY];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"token-changed" object:self];
}

- (NSString *)userIdentifier {
    return [self secureValueForKey:USER_ID_KEY];
}

- (void)setUserIdentifier:(NSString *)authToken {
    [self setSecureValue:authToken forKey:USER_ID_KEY];
}

- (void)setSecureValue:(NSString *)value forKey:(NSString *)key {
    if (value) {
        [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

- (NSString *)secureValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

@end
