//
//  KWMixedMapperWorker.h
//  KwarterSDK
//
//  Created by Ludovic Landry on 26/01/13.
//  Copyright (c) 2013 Kwarter, inc. All rights reserved.
//

#import "KWMapperWorker.h"

/**
 * Mixed mapper Worker used to return list of entity descriptions representing objetcs with different types.
 */
@interface KWMixedMapperWorker : KWMapperWorker

- (NSArray *)mappedResourceListError:(NSError **)errorPtr;

@end
