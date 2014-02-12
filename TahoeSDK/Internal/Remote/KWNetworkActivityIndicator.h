//
//  KWNetworkActivityIndicator.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * KWNetworkActivityIndicator is used for managing the activity indicator for the app
 * It keeps a count for when to turn on/off the indicator, all of the network clients
 * use this in order to make sure we don't hide it if the network is still being used.
 *
 * @since 1.0.0
 */
@interface KWNetworkActivityIndicator : NSObject

/**
 * Grab the shared activity indicator.
 */
+ (KWNetworkActivityIndicator *)sharedActivityIndicator;

/**
 * Tell the activity indicator that we are starting a network call.
 */
- (void)pushActivity;

/**
 * Tell the activity indicator that we are finished our network call, this should be done if we called pushActivity.
 */
- (void)popActivity;

@end
