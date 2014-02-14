//
//  KWReply.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/14/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KWMessage;

@interface KWReply : NSManagedObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) KWMessage *message;

@end
