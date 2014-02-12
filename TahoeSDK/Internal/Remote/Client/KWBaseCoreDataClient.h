//
//  KWClient.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KWBaseAuthClient.h"
#import "KWPipeline.h"

typedef void (^KWClientCompletionBlock)(NSArray *result, NSError *error);

@interface KWBaseCoreDataClient : KWPipeline

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (id)init; // default MOC
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc;

/**
 * Returns a list of objects using the given path as string, the request is built internaly.
* @param block The block executed when the checkin complete.
 */
- (void)getPath:(NSString *)path modelName:(NSString *)modelName completionBlock:(KWClientCompletionBlock)block;

/**
 * Returns a list of objects using the given url request.
 * @param block The block executed when the checkin complete.
 */
- (void)performURLRequest:(NSURLRequest *)request mapperName:(NSString *)mapperName completionBlock:(KWClientCompletionBlock)block;

/**
 * Returns a list of objects using the decoded json as array.
 * @param block The block executed when the checkin complete.
 */
- (void)objectsFromJSON:(NSArray *)jsonArray modelName:(NSString *)modelName completionBlock:(KWClientCompletionBlock)block;

@end
