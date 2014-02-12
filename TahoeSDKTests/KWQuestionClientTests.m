//
//  KWQuestionClientTests.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/6/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KWQuestionClient.h"
#import "KWQuestion.h"

@interface KWQuestionClientTests : XCTestCase

@end

@implementation KWQuestionClientTests

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testShouldNotBeListeningByDefault {
    KWQuestionClient *questionClient = [[KWQuestionClient alloc] init];
    XCTAssertFalse(questionClient.isListening);
}

- (void)testWhenListeningShouldBeAbleToCheckIfListening {
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
    
}

@end
