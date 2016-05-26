/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import <Foundation/Foundation.h>

@interface SnippetInfo : NSObject

@property (readonly) NSString *name;
@property (readonly) SEL action;
@property (readonly) BOOL needAdminAccess;

- (instancetype)initWithName: (NSString *)name
                  needsAdmin: (BOOL)needAdminAccess
                      action: (SEL)action;


@end
