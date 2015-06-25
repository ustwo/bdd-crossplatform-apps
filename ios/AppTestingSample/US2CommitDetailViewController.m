//
//  US2CommitDetailViewController.m
//  AppTestingSample
//
//  Created by Martin on 09/01/2015.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 ustwo™
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "US2CommitDetailViewController.h"

// Model
#import "US2Commit.h"

@interface US2CommitDetailViewController ()
@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView *loadingActivityIndicatorView;
@property (nonatomic, strong, readwrite) IBOutlet UILabel *authorNameLabel;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@end

@implementation US2CommitDetailViewController

- (instancetype)initWithCommit:(US2Commit *)commit
{
    self = [super init];
    if (self) {
        _commit = commit;
    }
    
    return self;
}


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self __initData];
    [self __initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self __updateData];
    [self __updateUserInterface];
}

#pragma mark - Data

- (void)__initData {
    self.isLoading = NO;
}

- (void)__updateData {
}

#pragma mark - User interface

- (void)__initUserInterface {
    [self __initView];
    [self __initAuthorNameLabel];
    [self __updateAuthor];
    [self __updateLoadingIndicator];
}

- (void)__initView {
    self.view.accessibilityIdentifier = @"commit_detail_view";
}

- (void)__initAuthorNameLabel {
    self.authorNameLabel.accessibilityIdentifier = @"commit-detail.author-name-label";
}

- (void)__updateUserInterface {
    [self __updateAuthor];
    [self __updateLoadingIndicator];
}

- (void)__updateAuthor {
    if (self.commit &&
        self.commit.message) {
        self.authorNameLabel.text = self.commit.message;
    }
    else {
        self.authorNameLabel.text = NSLocalizedString(@"error.no-author-name-available", nil);
    }
}

- (void)__updateLoadingIndicator {
    self.loadingActivityIndicatorView.hidden = !self.isLoading;
}

@end
