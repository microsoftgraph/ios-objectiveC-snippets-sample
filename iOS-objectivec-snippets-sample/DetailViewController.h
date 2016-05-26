/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import <UIKit/UIKit.h>

#import "Snippets.h"

@interface DetailViewController : UIViewController

@property(weak, nonatomic)Snippets *snippets;
@property(weak, nonatomic)SnippetInfo *snippetInfo;

@end

