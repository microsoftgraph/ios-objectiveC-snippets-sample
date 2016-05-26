/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

#import "DetailViewController.h"


@interface DetailViewController()<SnippetsDelegate>
@property (strong, nonatomic) IBOutlet UITextField *reponseTextField;
@property (strong, nonatomic) IBOutlet UILabel *snippetNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *accessLevelLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIStackView *resultStackView;
@property (strong, nonatomic) IBOutlet UILabel *result;

@end

@implementation DetailViewController


#pragma mark - View controller lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // start executing snippet
    [self.activityIndicatorView startAnimating];
    
    if (self.snippets && self.snippetInfo) {
        self.snippets.delegate = self;
        
        IMP imp = [self.snippets methodForSelector:self.snippetInfo.action];
        void (*func)(id, SEL) = (void *)imp;
        func(self.snippets, self.snippetInfo.action);
    }

}


#pragma mark - Managing snippets and snippetinfo

- (void)setSnippetInfo:(SnippetInfo *)newSnippetInfo {
    if (_snippetInfo != newSnippetInfo) {
        _snippetInfo = newSnippetInfo;
    }
    [self configureView];
}


- (void)configureView {
    if (self.snippetInfo) {
        self.snippetNameLabel.text = self.snippetInfo.name;
        self.accessLevelLabel.hidden = !self.snippetInfo.needAdminAccess;
    }
}

#pragma mark - snippet delegate

- (void)snippetSuccess:(NSString *)displayText {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.result.numberOfLines = 0;
        self.result.text = [NSString stringWithFormat:@"Success\n\n%@\n", displayText];
        [self.resultStackView addArrangedSubview:self.result];
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = true;
    });
}


- (void)snippetFailure:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.result.text = [NSString stringWithFormat:@"Failure\n\n%@\n%@",error.localizedDescription, error.userInfo];
        
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = true;
    });
}


@end
