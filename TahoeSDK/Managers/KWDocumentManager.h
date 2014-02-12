//
//  KWDocumentManager.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 29/11/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 * This class is the focal point for managing and saving
 * content to CoreData.
 *
 * @since 1.0.0
 */
@interface KWDocumentManager : NSObject

/**
 * An NSManagedObjectContext bound to the main thread.
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

/**
 * Return the shared singleton instance.
 */
+ (KWDocumentManager *)sharedDocument;

/**
 * Save the managed object context if needed.
 */
- (void)save;

/**
 * Reset the persistent store to an empty one ready to be used. Returns YES
 * on success.
 */
- (BOOL)resetStore;

@end
