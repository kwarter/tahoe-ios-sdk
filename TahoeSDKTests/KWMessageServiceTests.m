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


@interface KWMessageServiceTests : XCTestCase

@end

@implementation KWMessageServiceTests

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
    KWMessageService *messageService = [[KWMessageService alloc] init];
    //Question to answer
    KWQuestion *question = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Question"
                                    inManagedObjectContext:[[KWDocumentManager sharedDocument] managedObjectContext]];
    question.identifier = @"45985ed0-cf4d-48e4-885d-f8fe99c0d8a1";
    question.title = @"This is a title";
    question.choices = @[@"Choice A", @"Choice B", @"Choice C", @"Choice D"];

    XCTAssertTrue(YES);
}

@end
