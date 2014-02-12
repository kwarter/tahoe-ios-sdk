//
//  NSString+URLEncoding.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 30/11/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding usingPlusSignForSpaces:(BOOL)usesPlusForSpaces {
    NSString *urlEscaped = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self,
                                                                                                 NULL, (CFStringRef)@";/?:@&=$+{}<>, \t#\"\n",
                                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
    
    return (usesPlusForSpaces) ? [urlEscaped stringByReplacingOccurrencesOfString:@"%20" withString:@"+"] : urlEscaped;
}
@end
