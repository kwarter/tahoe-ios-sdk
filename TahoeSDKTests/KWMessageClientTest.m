//
//  KWMessageClientTest.m
//  TahoeSDK
//
//  Created by Elodie Ferrais on 2/13/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "KWMessageClient.h"

@interface KWMessageClientTest : XCTestCase

@end

@implementation KWMessageClientTest

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

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

-(void) testShouldReceiveOneMessage {

    KWMessageClient *messageClient = [[KWMessageClient alloc] init];
    __block BOOL hasCalledBack = NO;

    //Mock the http reponse
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub all those requests with "Hello World!" string
        NSBundle *myBundle = [NSBundle bundleForClass: [self class]];
        NSString *filePath = [myBundle pathForResource:@"TestDataMessageListSingle" ofType:@"json"];
        NSData *responseData = [NSData dataWithContentsOfFile:filePath];


        return [OHHTTPStubsResponse responseWithData:responseData statusCode:200 headers:@{@"Content-Type": @"text/json"}];
    }];

    [messageClient getMessagesForChannelIdentifier:@"test-channel" since:nil limit:0 completion:^(NSArray *messages, NSError *error) {
        NSLog(@"Callback has been called");
        hasCalledBack = YES;
    }];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }

    if (!hasCalledBack) {
        XCTFail(@"Login with username and password timed out.");
    }

}

@end
