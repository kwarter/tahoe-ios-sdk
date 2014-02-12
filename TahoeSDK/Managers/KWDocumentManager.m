//
//  KWDocumentManager.m
//  TahoeSDK
//
//  Created by Ludovic Landry on 29/11/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWDocumentManager.h"

@interface KWDocumentManager() {
    dispatch_queue_t queue;
}

@property (nonatomic, strong) NSString *storeType;
@property (nonatomic, strong) NSString *managedObjectModelName;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

- (void)addPersistentStoreToPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)aPersistentStoreCoordinator;

@end

@implementation KWDocumentManager

@synthesize storeType;
@synthesize managedObjectModelName;
@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

- (id)init {
    self = [super init];
    if (self) {
        self.storeType = NSSQLiteStoreType;
        self.managedObjectModelName = @"TahoeModel";
        queue = dispatch_queue_create("TahoeModelQueue", NULL);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldSave) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldSave) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

+ (KWDocumentManager *)sharedDocument {
    static KWDocumentManager *_sharedDocument = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDocument = [[self alloc] init];
    });
    return _sharedDocument;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!managedObjectModel) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *modelURL = [bundle URLForResource:self.managedObjectModelName withExtension:@"momd"];
        NSAssert1(modelURL, @"unable to find URL for managed object model %@", self.managedObjectModelName);
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return managedObjectModel;
}

- (NSURL *)urlForStoreType:(NSString *)type andDocumentNamed:(NSString *)documentName {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    // Create the document directory with intermediate directories if it does not exist (mostly used when running unit tests)
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentDirectory]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error != nil) {
            NSLog(@"error creating document directory, %@", error);
            return nil;
        }
    }
    
    NSString *storePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", documentName]];
    return [NSURL fileURLWithPath:storePath];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    __block id result = nil;
    dispatch_sync(queue, ^{
        if (!persistentStoreCoordinator)  {
            persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
            [self addPersistentStoreToPersistentStoreCoordinator:persistentStoreCoordinator];
        }
        result = persistentStoreCoordinator;
    });
    return result;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    return managedObjectContext;
}

- (void)addPersistentStoreToPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)aPersistentStoreCoordinator {
    NSURL *storeURL = [self urlForStoreType:self.storeType andDocumentNamed:self.managedObjectModelName];
    
    NSDictionary *options = @{
        NSInferMappingModelAutomaticallyOption: @(YES),
        NSMigratePersistentStoresAutomaticallyOption: @(YES)
    };
    
    NSError *openError = nil;
    id persistentStore = [aPersistentStoreCoordinator addPersistentStoreWithType:self.storeType
                                                                   configuration:nil URL:storeURL
                                                                         options:options error:&openError];
    if (!persistentStore) {
        NSError *deleteError = nil;
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&deleteError];
        persistentStore = [aPersistentStoreCoordinator addPersistentStoreWithType:self.storeType
                                                                    configuration:nil URL:storeURL
                                                                          options:options error:&openError];
    }
    NSAssert(persistentStore, @"failed to add persistent store, error is %@", [openError localizedDescription]);
}

- (void)shouldSave {
    if ([managedObjectContext hasChanges]) {
        NSError *error = nil;
        BOOL saved = [managedObjectContext save:&error];
        NSAssert(saved, @"failed to save with error %@", [error localizedDescription]);
    }
}

- (void)save {
    [self shouldSave];
}

- (BOOL)resetStore {
    
    __block NSError *error = nil;
    [managedObjectContext performBlockAndWait:^{
        
        // Save pending changes to avoid crash
        [self save];
        
        // Remove persistent store from coordinator
        
        [persistentStoreCoordinator.persistentStores enumerateObjectsUsingBlock:^(NSPersistentStore *persistentStore, NSUInteger idx, BOOL *stop) {
            [persistentStoreCoordinator removePersistentStore:persistentStore error:&error];
        }];
        
        if (!error) {
            // Erase the store on the disk
            NSURL *storeURL = [self urlForStoreType:self.storeType andDocumentNamed:self.managedObjectModelName];
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
            
            if (!error) {
                // Recreate an empty store ready to be used
                [self addPersistentStoreToPersistentStoreCoordinator:persistentStoreCoordinator];
            }
        }
    }];
    
    return (!error);
}

@end
