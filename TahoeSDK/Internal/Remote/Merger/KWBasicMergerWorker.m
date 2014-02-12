//
//  KWBasicMergerWorker.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 07/12/12.
//  Copyright (c) 2012 Kwarter, inc. All rights reserved.
//

#import "KWBasicMergerWorker.h"
#import "KWManagedObjectCache.h"
#import "KWMappedResource.h"

NSString *const KWMergerErrorDomain = @"com.kwarter.KWMergerErrorDomain";
NSString *const KWMergerErrorEntityNameKey = @"com.kwarter.EntityName";

@implementation KWBasicMergerWorker

- (NSEntityDescription *)entityDescription {
    NSString *entityName = self.mappedResource.entity;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    return entity;
}

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSString *entityName = self.mappedResource.entity;
    NSEntityDescription *entity = [self entityDescription];
    NSAssert2(entity != nil, @"failed to find entity %@ in %@", entityName, self.managedObjectContext);
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", self.mappedResource.identifier];
    [request setPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate]]];
    [request setFetchLimit:2];
    return request;
}

- (NSManagedObject *)managedObjectCreated:(BOOL *)created error:(NSError **)errorPtr {
    NSManagedObject *managedObject = nil;
    NSManagedObjectID *objectId = [self.objectCache managedObjectIdForCacheKey:self.cacheKey];
    
    if (objectId) {
        managedObject = [self.managedObjectContext existingObjectWithID:objectId error:nil];
    }
    
    if (!managedObject) { //lookup from fetchrequest
        NSEntityDescription *entity = [self entityDescription];
        if (!entity) {
            NSString *entityName = self.mappedResource.entity;
            if (!entityName) {
                entityName = (id) [NSNull null];
            }
            NSDictionary *userInfo = @{KWMergerErrorEntityNameKey: entityName};
            NSError *noEntityError = [NSError errorWithDomain:KWMergerErrorDomain code:KWMergerNoMatchingLocalEntityError userInfo:userInfo];
            if (errorPtr != NULL) {
                *errorPtr = noEntityError;
            }
            
            return nil; // abort
        }
        
        NSFetchRequest *request = [self fetchRequest];
        NSArray *result = [self.managedObjectContext executeFetchRequest:request error:errorPtr];
        if (!result) {
            return nil;
        }
        managedObject = [result lastObject];
    }
    
    if (!managedObject) {
        NSString *entityName = self.mappedResource.entity;
        managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    }
    
    //set the cache
    [self.objectCache setManagedObjectID:[managedObject objectID] forCacheKey:self.cacheKey];
    
    NSDictionary *fields = self.mappedResource.fields;
    NSDictionary *propertiesByName = [[managedObject entity] propertiesByName];
    [fields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        //prevent too many observers to be triggered
		id value = obj;
		NSString *property = key;
		if ([propertiesByName objectForKey:property] != nil) {
            if (value == [NSNull null]) {
                [managedObject setValue:nil forKey:property];
            } else {
                if ([value isKindOfClass:[NSDecimalNumber class]]) {
                    value = [NSNumber numberWithDouble:[value doubleValue]];
                }
                if (![[managedObject valueForKey:property] isEqual:value]) {
                    [managedObject setValue:value forKey:property];
                }
            }
        }
    }];
    
    //handle dependancies
    NSDictionary *relations = self.mappedResource.relations;
    [relations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *relationName = key;
        NSEntityDescription *entity = [managedObject entity];
        NSRelationshipDescription *relationDescription = [[entity relationshipsByName] objectForKey:relationName];
        
        NSAssert2(relationDescription, @"unable to find relationship named %@ in entity %@", relationName, [entity name]);
        NSRelationshipDescription *inverseRelation = [relationDescription inverseRelationship];
        NSEntityDescription *relatedEntity = [inverseRelation entity];
        
        //consider NSSets as many to one relationships. Transform it to an array to prevent duplicate code path
        if ([obj isKindOfClass:[NSSet class]]) {
            obj = [obj allObjects];
        }
        if ([obj isKindOfClass:[NSOrderedSet class]]) {
            obj = [obj allObjects];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            
            //if we have an ordered relashionship we provide an ordered set
            id setOrOrderedSet;
            if ([relationDescription isOrdered]) {
                setOrOrderedSet = [NSMutableOrderedSet orderedSetWithCapacity:[obj count]];
            } else {
                setOrOrderedSet = [NSMutableSet setWithCapacity:[obj count]];
            }
            
            //to many relationship
            for (KWMappedResource *relatedMappedResource in obj) {
                KWMergerWorker *worker = [KWMergerWorker workerForMappedResource:relatedMappedResource];
                worker.managedObjectContext = self.managedObjectContext;
                worker.objectCache = self.objectCache;
                NSManagedObject *relatedManagedObject = [worker managedObjectCreated:NULL error:NULL];
                NSAssert([[relatedManagedObject entity] isEqual:relatedEntity] || [[relatedManagedObject entity] isKindOfEntity:relatedEntity],
                         @"expected entity %@, got %@", [relatedEntity name], [[relatedManagedObject entity] name]);
                [setOrOrderedSet addObject:relatedManagedObject];
            }
            [managedObject setValue:setOrOrderedSet forKey:relationName];
            
        } else {
            KWMappedResource *relatedMappedResource = obj;
            KWMergerWorker *worker = [KWMergerWorker workerForMappedResource:relatedMappedResource];
            worker.managedObjectContext = self.managedObjectContext;
            worker.objectCache = self.objectCache;
            NSManagedObject *relatedManagedObject = [worker managedObjectCreated:NULL error:NULL];
            NSAssert([[relatedManagedObject entity] isEqual:relatedEntity] || [[relatedManagedObject entity] isKindOfEntity:relatedEntity],
                     @"expected entity %@, got %@", [relatedEntity name], [[relatedManagedObject entity] name]);
            if ([inverseRelation isToMany]) {
                [managedObject setValue:relatedManagedObject forKey:[relationDescription name]];
            } else {
                [relatedManagedObject setValue:managedObject forKey:[inverseRelation name]];
            }
        }
    }];
    
    return managedObject;
}

@end
