//
//  KWReply.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/14/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWReply.h"
#import "KWMessage.h"

@interface KWReply ()

@property (nonatomic, strong) KWMessage *message_;

@end

@implementation KWReply

@dynamic identifier;
@dynamic title;
@dynamic timestamp;
@dynamic data;
@dynamic message;
@dynamic message_;

@end
