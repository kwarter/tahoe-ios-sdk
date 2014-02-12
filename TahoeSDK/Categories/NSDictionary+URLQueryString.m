//
//  NSDictionary+URLQueryString.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "NSDictionary+URLQueryString.h"
#import "NSString+URLEncoding.h"

@implementation NSDictionary (URLQueryString)

- (NSString *)URLQueryStringUsingPlusSignForSpaces:(BOOL)usesPlusForSpaces {
    
    NSMutableArray *parts = [NSMutableArray array];
    
    NSArray *allKeysSorted = [self.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [allKeysSorted enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
        id object = [self objectForKey:key];
        
        NSString *parameter = [key description];
        NSString *value = [object description];
        NSString *encodedTuple = [NSString stringWithFormat:@"%@=%@",
                                  [parameter urlEncodeUsingEncoding:NSUTF8StringEncoding usingPlusSignForSpaces:usesPlusForSpaces],
                                  [value urlEncodeUsingEncoding:NSUTF8StringEncoding usingPlusSignForSpaces:usesPlusForSpaces]];
        [parts addObject:encodedTuple];
    }];
    
    return [parts componentsJoinedByString:@"&"];
}

@end
