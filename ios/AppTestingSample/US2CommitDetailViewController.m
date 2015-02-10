//
//  US2CommitDetailViewController.m
//  AppTestingSample
//
//  Created by Martin on 09/01/2015.
//  Copyright (c) 2015 ustwo. All rights reserved.
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
        self.authorNameLabel.text = @"No author name available";
    }
}

- (void)__updateLoadingIndicator {
    self.loadingActivityIndicatorView.hidden = !self.isLoading;
}

@end
