//
//  KWQuestion.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/14/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KWMessage.h"

@interface KWQuestion : KWMessage

@property (nonatomic, strong) NSArray *choices;
@property (nonatomic, strong) NSString *title;

@end
