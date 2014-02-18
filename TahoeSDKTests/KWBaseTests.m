//
//  KWBaseTests.m
//  TahoeSDK
//
//  Created by Elodie Ferrais on 2/17/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWBaseTests.h"

@implementation KWBaseTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (NSData *)getDataFromJsonFile:(NSString *)fileName {
    NSBundle *myBundle = [NSBundle bundleForClass: [self class]];
    NSString *filePath = [myBundle pathForResource:fileName ofType:@"json"];
    NSData *responseData = [NSData dataWithContentsOfFile:filePath];
    return responseData;
}

@end
