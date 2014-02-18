//
//  KWChannelServiceDelegateHelper.h
//  TahoeSDK
//
//  Created by Elodie Ferrais on 2/17/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWChannelServiceDelegate.h"
#import "KWMessage.h"

@interface KWChannelServiceDelegateHelper : NSObject <KWChannelServiceDelegate>

- (id)initWithHistoryBlock:(void(^)(NSArray *history))historyBlock
              messageBlock:(void(^)(KWMessage *message))messageBlock
                errorBlock:(void(^)(NSError *error))errorBlock;

@end
