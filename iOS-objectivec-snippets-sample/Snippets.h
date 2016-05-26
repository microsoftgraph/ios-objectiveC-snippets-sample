/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import <Foundation/Foundation.h>
#import "SnippetInfo.h"
#import "Authentication.h"

@protocol SnippetsDelegate<NSObject>

- (void)snippetSuccess:(NSString *)displayText;
- (void)snippetFailure:(NSError *)error;

@end


@interface Snippets : NSObject

@property (strong, nonatomic, readonly) NSArray *snippetGroups;
@property (strong, nonatomic, readonly) NSArray *snippetGroupNames;
@property (assign, nonatomic) id<SnippetsDelegate> delegate;

- (void)setGraphClientWithAuthProvider:(id<MSAuthenticationProvider>)provider;

@end
