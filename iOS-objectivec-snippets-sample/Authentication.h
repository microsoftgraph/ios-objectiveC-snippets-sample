/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import <Foundation/Foundation.h>
#import <MSGraphSDK-NXOAuth2Adapter/MSGraphSDKNXOAuth2.h>
#import <MSGraphSDK/MSGraphSDK.h>

@class NXOAuth2AuthenticationProvider;

@interface Authentication : NSObject

-(NXOAuth2AuthenticationProvider *)authProvider;
-(void) connectToGraphWithClientId:(NSString *)clientId
                            scopes:(NSArray *)scopes
                        completion:(void (^)(NSError *error))completion;
-(void) disconnect;



@end



 