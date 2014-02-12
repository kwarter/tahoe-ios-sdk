//
//  KWMessage.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KWChannel;

@interface KWMessage : NSManagedObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) KWChannel *channel;

@end
