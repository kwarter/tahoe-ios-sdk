//
//  KWQuestionMapperWorker.h
//  TahoeSDK
//
//  Created by Ludovic Landry on 2/7/14.
//  Copyright (c) 2014 Kwarter, inc. All rights reserved.
//

#import "KWMapperWorker.h"
#import "KWMessageMapperRegistration.h"

/**
 * Mapper Worker returning an entity description corresponding to a `KWQuestion` object.
 */
@interface KWQuestionMapperWorker : KWMapperWorker <KWMessageMapperRegistration>

@end
