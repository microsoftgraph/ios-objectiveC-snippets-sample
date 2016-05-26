/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "Authentication.h"
#import "AuthenticationConstants.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "SnippetInfo.h"
#import "Snippets.h"
#import <MSGraphSDK-NXOAuth2Adapter/MSGraphSDKNXOAuth2.h>


@interface MasterViewController ()

@property (strong, nonatomic)Snippets *snippets;
@property (strong, nonatomic)SnippetInfo *snippetInfo;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.snippets = [[Snippets alloc] init];
    [self.snippets setGraphClientWithAuthProvider:(id)self.authProvider];
}



- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disconnectTapped:(id)sender {
    
    [self.authProvider logout];
    [self.navigationController.splitViewController dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        
        controller.snippets = self.snippets;
        controller.snippetInfo = self.snippets.snippetGroups[indexPath.section][indexPath.row];

        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.snippets.snippetGroupNames[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.snippets.snippetGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray*)self.snippets.snippetGroups[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    SnippetInfo *snippet = self.snippets.snippetGroups[indexPath.section][indexPath.row];
    cell.textLabel.text = snippet.name;
    
    if(snippet.needAdminAccess){
        cell.detailTextLabel.text = @"Requires admin access";
    }
    else {
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

@end
