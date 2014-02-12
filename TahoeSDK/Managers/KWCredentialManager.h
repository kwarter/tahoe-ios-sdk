//
//  KWCredentialManager.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 25/11/12.
//  Copyright (c) 2012 Ludovic Landry. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The KWCredentialManager persists the currently authorized user's
 * unique identifier and access token.
 * The data are saved on disk after user first login. This class is
 * used by the KWLoginManager to retrieve the user info.
 *
 * @since 1.0.0
 */
@interface KWCredentialManager : NSObject

/**
 * The currently authenticated user's access token. Nil if the user is not logged.
 */
@property (nonatomic, strong) NSString *accessToken;

/**
 * The currently authenticated user's unique identifier. Nil if the user is not logged.
 */
@property (nonatomic, strong) NSString *userIdentifier;

/**
 * Recovers the shared singleton instance of the KWCredentialManager.
 */
+ (KWCredentialManager *)sharedManager;

/**
 * Clears user's access token and unique identifier.
 */
- (void)clearSavedCredentials;

@end
