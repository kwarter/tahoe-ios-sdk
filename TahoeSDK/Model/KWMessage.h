//
//  KWMessage.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/14/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KWChannel, KWReply;

@interface KWMessage : NSManagedObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) KWChannel *channel;
@property (nonatomic, strong) NSOrderedSet *replyOrderedSet;
@property (nonatomic, strong) KWReply *userReply;

@end

@interface KWMessage (CoreDataGeneratedAccessors)

- (void)insertObject:(KWReply *)value inReplyOrderedSetAtIndex:(NSUInteger)idx;
- (void)removeObjectFromReplyOrderedSetAtIndex:(NSUInteger)idx;
- (void)insertReplyOrderedSet:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeReplyOrderedSetAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInReplyOrderedSetAtIndex:(NSUInteger)idx withObject:(KWReply *)value;
- (void)replaceReplyOrderedSetAtIndexes:(NSIndexSet *)indexes withReplyOrderedSet:(NSArray *)values;
- (void)addReplyOrderedSetObject:(KWReply *)value;
- (void)removeReplyOrderedSetObject:(KWReply *)value;
- (void)addReplyOrderedSet:(NSOrderedSet *)values;
- (void)removeReplyOrderedSet:(NSOrderedSet *)values;

@end
