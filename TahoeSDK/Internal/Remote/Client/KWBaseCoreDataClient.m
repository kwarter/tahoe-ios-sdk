//
//  KWClient.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWBaseCoreDataClient.h"
#import "KWDocumentManager.h"
#import "KWFetcher.h"
#import "KWMapper.h"
#import "KWMerger.h"

@interface KWBaseCoreDataClient ()
- (void)loadPipelineUsingNetwork:(BOOL)useNetwork;
@end

@implementation KWBaseCoreDataClient

@synthesize managedObjectContext;

- (id)init {
    self = [self initWithManagedObjectContext:[[KWDocumentManager sharedDocument] managedObjectContext]];
    return self;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc {
    self = [super init];
    if (self) {
        self.managedObjectContext = moc;
    }
    return self;
}

- (void)loadPipeline {
    [self loadPipelineUsingNetwork:YES];
}

- (void)loadPipelineUsingNetwork:(BOOL)useNetwork {
    NSMutableArray *pipeline = [NSMutableArray array];
    
    if (useNetwork) {
        KWFetcher *fetcher = [[KWFetcher alloc] init];
        [pipeline addObject:fetcher];
    }

    KWMapper *mapper = [[KWMapper alloc] init];
    [pipeline addObject:mapper];
    
    KWMerger *merger = [[KWMerger alloc] initWithManagedObjectContext:self.managedObjectContext];
    [pipeline addObject:merger];
    
    self.components = [NSArray arrayWithArray:pipeline];
}

- (void)getPath:(NSString *)path modelName:(NSString *)modelName completionBlock:(KWClientCompletionBlock)block {
    NSURLRequest *request = [[KWBaseAuthClient sharedClient] requestWithMethod:@"GET" path:path parameters:nil];
    [self performURLRequest:request mapperName:modelName completionBlock:block];
}

- (void)performURLRequest:(NSURLRequest *)request mapperName:(NSString *)mapperName completionBlock:(KWClientCompletionBlock)block {
    [self loadPipelineUsingNetwork:YES];
    [self process:request mapperName:mapperName completionBlock:^(id result, NSError *error) {
        block(result, error);
    }];
}

- (void)objectsFromJSON:(NSArray *)jsonArray modelName:(NSString *)modelName completionBlock:(KWClientCompletionBlock)block {
    [self loadPipelineUsingNetwork:NO];
    [self process:jsonArray mapperName:modelName completionBlock:^(NSArray *result, NSError *error) {
        block(result, error);
    }];
}

@end
