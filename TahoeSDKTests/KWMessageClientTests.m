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

@interface KWMessageClientTests : XCTestCase

@end

@implementation KWMessageClientTests

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

- (void)testShouldReceiveOneMessage {

    KWMessageClient *messageClient = [[KWMessageClient alloc] init];
    __block BOOL hasCalledBack = NO;
    
    NSData *responseData = [self getDataFromJsonFile:@"TestDataMessageListSingle"];
    
    //Mock the http reponse
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub all those requests with Json responseData content
        return [OHHTTPStubsResponse responseWithData:responseData statusCode:200 headers:@{@"Content-Type": @"text/json"}];
    }];

    [messageClient getMessagesForChannelIdentifier:@"test-channel" since:nil limit:0 completion:^(NSArray *messages, NSError *error) {
        NSError *jsonError = nil;
        NSArray *inputData = [[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError] objectForKey:@"messages"];
        XCTAssertNil(jsonError);
        XCTAssertNotNil(inputData);
        
        XCTAssertNotNil(messages);
        XCTAssertNil(error);
        XCTAssertTrue([inputData count] == [messages count]);
        
        KWMessage *message = [messages objectAtIndex:0];
        NSDictionary *messageJson = [inputData objectAtIndex:0];
        
        //Message attributes
        XCTAssertTrue([[messageJson objectForKey:@"id"] isEqualToString:message.identifier]);
        XCTAssertTrue([[messageJson objectForKey:@"title"] isEqualToString:message.title]);
        
        //Question attributes
        XCTAssertTrue([message isKindOfClass:[KWQuestion class]]);
        KWQuestion *question = (KWQuestion *)message;
        XCTAssertNotNil(question.choices);
        NSArray *choices = question.choices;
        NSArray *choicesJson = [messageJson valueForKeyPath:@"data.choices"];
        XCTAssertTrue(4 ==[question.choices count]);
        XCTAssertTrue([[choicesJson objectAtIndex:0] isEqualToString: [choices objectAtIndex:0]]);
        XCTAssertTrue([[choicesJson objectAtIndex:1] isEqualToString:[choices objectAtIndex:1]]);
        XCTAssertTrue([[choicesJson objectAtIndex:2] isEqualToString:[choices objectAtIndex:2]]);
        XCTAssertTrue([[choicesJson objectAtIndex:3] isEqualToString:[choices objectAtIndex:3]]);
        
        hasCalledBack = YES;
    }];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:300];
    while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }

    if (!hasCalledBack) {
        XCTFail(@"Login with username and password timed out.");
    }

}

-(NSData*) getDataFromJsonFile: (NSString *) fileName {
    NSBundle *myBundle = [NSBundle bundleForClass: [self class]];
    NSString *filePath = [myBundle pathForResource:fileName ofType:@"json"];
    NSData *responseData = [NSData dataWithContentsOfFile:filePath];
    return responseData;
}

@end
