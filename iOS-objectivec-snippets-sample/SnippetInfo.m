/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "SnippetInfo.h"

@implementation SnippetInfo



- (instancetype)initWithName: (NSString *)name
                  needsAdmin: (BOOL)needAdminAccess
                      action: (SEL)action  {
    self = [super init];
    if (self) {        
        _name = [name copy];
        _needAdminAccess = needAdminAccess;
        _action = action;
    }
    return self;
    
}

@end
