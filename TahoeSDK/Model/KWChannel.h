//
//  KWChannel.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KWMessage;

@interface KWChannel : NSManagedObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSOrderedSet *messageOrderedSet;

@end

@interface KWChannel (CoreDataGeneratedAccessors)

- (void)insertObject:(KWMessage *)value inMessageOrderedSetAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMessageOrderedSetAtIndex:(NSUInteger)idx;
- (void)insertMessageOrderedSet:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMessageOrderedSetAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMessageOrderedSetAtIndex:(NSUInteger)idx withObject:(KWMessage *)value;
- (void)replaceMessageOrderedSetAtIndexes:(NSIndexSet *)indexes withMessageOrderedSet:(NSArray *)values;
- (void)addMessageOrderedSetObject:(KWMessage *)value;
- (void)removeMessageOrderedSetObject:(KWMessage *)value;
- (void)addMessageOrderedSet:(NSOrderedSet *)values;
- (void)removeMessageOrderedSet:(NSOrderedSet *)values;

@end
