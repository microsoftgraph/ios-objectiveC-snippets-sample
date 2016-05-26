/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "Authentication.h"
#import "AuthenticationConstants.h"
#import "ConnectViewController.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import <MSGraphSDK-NXOAuth2Adapter/MSGraphSDKNXOAuth2.h>


@interface ConnectViewController()
@property (strong, nonatomic) Authentication *authentication;
@end

@implementation ConnectViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    _authentication = [[Authentication alloc]init];
}

- (IBAction)connectTapped:(id)sender {
    
    NSArray *scopes = [kScopes componentsSeparatedByString:@","];
    [self.authentication connectToGraphWithClientId:kClientId scopes:scopes completion:^(NSError *error) {
        if (!error) {
            
            [self performSegueWithIdentifier:@"showSplitView" sender:nil];
            NSLog(@"Authentication successful.");
            
        }
        else{
            NSLog(@"Authentication failed - %@", error.localizedDescription);
            
        };
    }];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UISplitViewController *splitViewController = segue.destinationViewController;
    
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    navigationController = (UINavigationController*)splitViewController.viewControllers.firstObject;
    MasterViewController *mc =(MasterViewController*)navigationController.topViewController;
    mc.authProvider =  self.authentication.authProvider;
    splitViewController.delegate = self;
    
 
    
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] snippets] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}



@end
