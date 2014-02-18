//
//  KWMessageService.m
//  TahoeSDK
//
//  Created by Elodie Ferrais on 2/17/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KWMessageService.h"
#import "KWQuestion.h"
#import "KWDocumentManager.h"
#import "KWMessageClient.h"
#import "KWBaseTests.h"
#import "KWChannelService.h"
#import "KWChannelServiceDelegateHelper.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface KWChannelServiceTests : KWBaseTests

@end

@implementation KWChannelServiceTests

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

- (void)testshouldSubscribeToAChannel {
    //Data to test
    NSData *responseData = [self getDataFromJsonFile:@"TestDataMessageListSingle"];
    __block BOOL hasCalledBack = NO;
    
    
    KWChannelServiceDelegateHelper *channelServiceDelegateHelper = [[KWChannelServiceDelegateHelper alloc] initWithHistoryBlock:^(NSArray *history) {
        NSError *jsonError = nil;
        NSArray *inputData = [[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError] objectForKey:@"messages"];
        XCTAssertNil(jsonError);
        XCTAssertNotNil(inputData);
        
        XCTAssertNotNil(history);
        XCTAssertTrue([inputData count] == [history count]);
        
        KWMessage *message = [history objectAtIndex:0];
        NSDictionary *messageJson = [inputData objectAtIndex:0];
        
        //Message attributes
        XCTAssertTrue([[messageJson objectForKey:@"id"] isEqualToString:message.identifier]);
        XCTAssertTrue([[messageJson objectForKey:@"title"] isEqualToString:message.title]);
        //TODO add check for the timestamp
        
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
    } messageBlock:NULL errorBlock:NULL];
    
    KWChannelService *channelService = [[KWChannelService alloc] initWithChannelIdentifier:@"1" delegate:channelServiceDelegateHelper];
    //Mock the http reponse
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub all those requests with Json responseData content
        return [OHHTTPStubsResponse responseWithData:responseData statusCode:200 headers:@{@"Content-Type": @"text/json"}];
    }];
    
    [channelService subscribe];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:300];
    while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    
    if (!hasCalledBack) {
        XCTFail(@"Login with username and password timed out.");
    }
}

- (void)testshouldReceiveQuestionAfterDelay {
    __block BOOL hasCalledBack = NO;
    
    KWChannelServiceDelegateHelper *channelServiceDelegateHelper = [[KWChannelServiceDelegateHelper alloc] initWithHistoryBlock:NULL
                                                                                                                   messageBlock:NULL
                                                                                                                     errorBlock:^(NSError * error) {
                                                                                                                         XCTAssertNotNil(error);
                                                                                                                         
                                                                                                                         hasCalledBack = YES;
                                                                                                                   }];
    
    KWChannelService *channelService = [[KWChannelService alloc] initWithChannelIdentifier:@"1" delegate:channelServiceDelegateHelper];
    //Mock the http reponse
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub all those requests with Json responseData content
        return [OHHTTPStubsResponse responseWithData:nil statusCode:500 headers:@{@"Content-Type": @"text/json"}];
    }];
    
    [channelService subscribe];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:300];
    while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    
    if (!hasCalledBack) {
        XCTFail(@"Login with username and password timed out.");
    }
}

- (void)testshouldReceiveError {
    //Data to test
    NSData *responseData = [self getDataFromJsonFile:@"TestDataMessageListSingle"];
    __block BOOL hasCalledBack = NO;
    
    
    KWChannelServiceDelegateHelper *channelServiceDelegateHelper = [[KWChannelServiceDelegateHelper alloc] initWithHistoryBlock:NULL
                                                                                                                   messageBlock:^(KWMessage *message) {
                                                                                                                       NSError *jsonError = nil;
                                                                                                                       NSArray *inputData = [[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError] objectForKey:@"messages"];
                                                                                                                       XCTAssertNil(jsonError);
                                                                                                                       XCTAssertNotNil(inputData);
                                                                                                                       
                                                                                                                       XCTAssertNotNil(message);
                                                                                                                       
                                                                                                                       NSDictionary *messageJson = [inputData objectAtIndex:0];
                                                                                                                       
                                                                                                                       //Message attributes
                                                                                                                       XCTAssertTrue([[messageJson objectForKey:@"id"] isEqualToString:message.identifier]);
                                                                                                                       XCTAssertTrue([[messageJson objectForKey:@"title"] isEqualToString:message.title]);
                                                                                                                       //TODO add check for the timestamp
                                                                                                                       
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
                                                                                                                       
                                                                                                                   } errorBlock:NULL];
    
    KWChannelService *channelService = [[KWChannelService alloc] initWithChannelIdentifier:@"1" delegate:channelServiceDelegateHelper];
    //Mock the http reponse
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES; // Stub ALL requests without any condition
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        // Stub all those requests with Json responseData content
        return [OHHTTPStubsResponse responseWithData:responseData statusCode:200 headers:@{@"Content-Type": @"text/json"}];
    }];
    
    [channelService subscribe];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:300];
    while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    
    if (!hasCalledBack) {
        XCTFail(@"Login with username and password timed out.");
    }
}


@end
