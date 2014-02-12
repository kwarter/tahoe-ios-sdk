//
//  NSObject+Registration.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 30/11/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "NSObject+Registration.h"
#import <objc/runtime.h>

@implementation NSObject (Registration)

+ (NSArray *)classesConformingTo:(Protocol *)protocol {
    
    NSMutableArray *result = [NSMutableArray array];
    int count = objc_getClassList(NULL, 0);
    NSMutableData *classData = [NSMutableData dataWithLength:sizeof(Class) * count];
    
    Class *classes = (Class*)[classData mutableBytes];
    objc_getClassList(classes, count);
    Protocol *searchedProtocol = protocol;
    for (int i = 0; i < count; ++i) {
        Class currClass = classes[i];
        if (class_conformsToProtocol(currClass, searchedProtocol)) {
            [result addObject:currClass];
        }
    }
    
    return [NSArray arrayWithArray:result];
}

+ (NSArray *) methodNamesForClassNamed:(NSString *) className { return [self methodNamesForClass:NSClassFromString(className)]; }
+ (NSArray *) methodNamesForClass:(Class) aClass
{
    Method *methods;
    unsigned int methodCount;
    if ((methods = class_copyMethodList(aClass, &methodCount)))
    {
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:methodCount];
        
        while (methodCount--)
			[results addObject:[NSString stringWithCString: sel_getName(method_getName(methods[methodCount])) encoding: NSASCIIStringEncoding]];
        
        free(methods);
        return results;
    }
    return nil;
}

@end
