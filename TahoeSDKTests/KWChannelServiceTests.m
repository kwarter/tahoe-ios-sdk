//
//  KWQuestionClientTests.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/6/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "KWChannelService.h"
#import "KWMessageClient.h"

@interface KWChannelServiceTests : XCTestCase
@property (nonatomic, assign)NSConditionLock *theLock;
@end

@implementation KWChannelServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testShouldSubscribeToAChannel {

    // Create the NSURLConnection mock
    KWChannelService *channelService = [[KWChannelService alloc] initWithChannelIdentifier:@"test-channel" delegate:self];


    /*id urlConnectionMock = [OCMockObject mockForClass:[NSURLConnection class]];
    NSURLConnection *urlConnectionStub = [[urlConnectionMock stub] andDo:^(NSInvocation *invocation) {
        NSLog(@"and DO has been called");
        [self.theLock unlockWithCondition:1];

    }];
    [urlConnectionStub start];
    */
    // Invoke the method on the object that triggers the creation of the NSURLConnection
    [channelService subscribe];

    [self.theLock lockWhenCondition:1];


    // Mock the response data
    /*int statusCode = 200;
    id responseMock = [OCMockObject mockForClass:[NSHTTPURLResponse class]];
    [[[responseMock stub] andReturnValue:OCMOCK_VALUE(statusCode)] statusCode];
    [[urlConnectionOperationMock expect] connection:dummyUrlConnection didReceiveResponse:responseMock];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"InputTest" ofType:@"json"];
    NSData *responseData = [NSData dataWithContentsOfFile:filePath];
    [[urlConnectionOperationMock expect] connection:dummyUrlConnection didReceiveData:responseData];
    [[urlConnectionOperationMock expect] connectionDidFinishLoading:dummyUrlConnection];*/
}

/*- (void)testWhenListeningShouldBeAbleToCheckIfListening {
    KWQuestionClient *questionClient = [[KWQuestionClient alloc] init];
    [questionClient startListeningForQuestionsWithCompletion:^(KWQuestion *question, NSError *error) {}];
    XCTAssertTrue(questionClient.isListening);
}

- (void)testAfterStoppingListeningForQuestionsShouldReturnFalseWhenCheckingIfListening {
    KWQuestionClient *questionClient = [[KWQuestionClient alloc] init];
    [questionClient startListeningForQuestionsWithCompletion:^(KWQuestion *question, NSError *error) {}];
    [questionClient stopListeningForQuestions];
    XCTAssertFalse(questionClient.isListening);
}

- (void)testShouldRecieveOneQuestion {
    KWQuestionClient *questionClient = [[KWQuestionClient alloc] init];
    [questionClient startListeningForQuestionsWithCompletion:^(KWQuestion *question, NSError *error) {
        XCTAssertNotNil(question);
        XCTAssertEqual(question.identifier, @"1");
        XCTAssertEqual(question.title, @"What is favorite number?");
        XCTAssertNil(error);
    }];
}

- (void)testShouldRecieveManyQuestions {

}

- (void)testShouldBeAbleToStopQuestionLoop {

}*/

- (void)channelService:(KWChannelService *)service didReceiveHistory:(NSArray *)messages {
    NSLog(@"History");

}
- (void)channelService:(KWChannelService *)service didReceiveMessage:(KWMessage *)message {
    NSLog(@"Message");
}

- (void)channelService:(KWChannelService *)service didReceiveError:(NSError *)error {
    NSLog(@"Error");
}


@end
