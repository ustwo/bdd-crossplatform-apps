//
//  US2RepositoryCommitsViewController.m
//  AppTestingSample
//
//  Created by Martin on 08/01/2015.
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

#import "US2RepositoryCommitsViewController.h"

// Model
#import "US2Commit.h"

// View
#import "US2CommitTableViewCell.h"

// Controller
#import "US2CommitDetailViewController.h"
#import "US2Server.h"

@interface US2RepositoryCommitsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView *loadingActivityIndicatorView;
@property (nonatomic, strong, readwrite) IBOutlet UILabel *errorLabel;
@property (nonatomic, strong, readwrite) IBOutlet UIImageView *repositoryIndicatorImageView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, strong, readwrite) NSData *urlData;
@property (nonatomic, strong, readwrite) NSArray *commits;
@property (nonatomic, copy, readwrite) NSString *repositoryName;
@property (nonatomic, assign, readwrite) BOOL isPrivateRepository;
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@end

@implementation US2RepositoryCommitsViewController

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
    self.commits = nil;
    self.isLoading = NO;
    self.repositoryName = @"";
    self.errorMessage = @"";
}

- (void)__updateData {
    [self __requestRepositoryByRepositoryName:@"US2FormValidator"];
}

- (void)__requestRepositoryByRepositoryName:(NSString *)repositoryName {
    self.isLoading = YES;
    [self __updateLoadingIndicator];
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    [components setScheme:[US2Server scheme]];
    [components setHost:[US2Server host]];
    [components setPort:[US2Server port]];
    [components setPath:[NSString stringWithFormat:@"/repos/ustwo/%@", repositoryName]];
    NSURL *url = [components URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.isLoading = NO;
        
        if (error) {
            self.repositoryName = @"";
            self.errorMessage = @"Could not load commits";
        }
        else {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (jsonDictionary == nil) {
                self.repositoryName = nil;
                self.errorMessage = @"Could not load commits";
            }
            else {
                NSString *repositoryName = [jsonDictionary objectForKey:@"name"];
                if ([repositoryName isKindOfClass:NSString.class]) {
                    self.repositoryName = repositoryName;
                }
                
                self.isPrivateRepository = ((NSNumber *)[jsonDictionary objectForKey:@"private"]).boolValue;
                
                // Only if valid repository data is retrieved request the final commits data
                [self __requestCommitsByRepositoryName:@"US2FormValidator" withCount:4];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __updateRepositoryTitle];
            [self __updateLoadingIndicator];
            [self __updateRepositoryIndicatorImageView];
            
            if (self.errorMessage) {
                [self __presentErrorWithMessage:self.errorMessage];
            }
        });
    }];
    [dataTask resume];
}

- (void)__requestCommitsByRepositoryName:(NSString *)repositoryName withCount:(NSUInteger)count {
    self.isLoading = YES;
    [self __updateLoadingIndicator];
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    [components setScheme:[US2Server scheme]];
    [components setHost:[US2Server host]];
    [components setPort:[US2Server port]];
    [components setQuery:[NSString stringWithFormat:@"per_page=%lu", (unsigned long)count]];
    [components setPath:[NSString stringWithFormat:@"/repos/ustwo/%@/commits", repositoryName]];
    NSURL *url = [components URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.isLoading = NO;
        
        NSHTTPURLResponse *httpUrlResponse = nil;
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            httpUrlResponse = (NSHTTPURLResponse *)response;
        }
        
        if (error ||
            httpUrlResponse.statusCode > 400) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.errorMessage = @"Could not load commits";
            });
        }
        else {
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (jsonArray == nil ||
                jsonArray.count == 0) {
                self.commits = [@[] mutableCopy];
                self.errorMessage = @"No commits available";
            }
            else {
                self.commits = [self __commitsFromJSONArray:jsonArray];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __updateUserInterface];
            
            if (self.errorMessage) {
                [self __presentErrorWithMessage:self.errorMessage];
            }
        });
    }];
    [dataTask resume];
}

#pragma mark - Parsing

- (US2Commit *)__commitFromDictionary:(NSDictionary *)dictionary {
    US2Commit *commit = [[US2Commit alloc] init];
    
    id sha = [dictionary objectForKey:@"sha"];
    if ([sha isKindOfClass:NSString.class]) {
        commit.sha = sha;
    }
    
    id commitDictionary = [dictionary objectForKey:@"commit"];
    if ([commitDictionary isKindOfClass:NSDictionary.class]) {
        id message = [commitDictionary objectForKey:@"message"];
        if ([message isKindOfClass:NSString.class]) {
            commit.message = message;
        }
        
        id authorDictionary = [commitDictionary objectForKey:@"author"];
        if ([authorDictionary isKindOfClass:NSDictionary.class]) {
            id date = [authorDictionary objectForKey:@"date"];
            if ([date isKindOfClass:NSString.class]) {
                commit.date = date;
            }
        }
    }
    
    return commit;
}

- (NSArray *)__commitsFromJSONArray:(NSArray *)array {
    NSMutableArray *commits = [@[] mutableCopy];
    
    if ([array isKindOfClass:NSArray.class]) {
        [array enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger index, BOOL *stop) {
            if ([dictionary isKindOfClass:NSDictionary.class]) {
                US2Commit *commit = [self __commitFromDictionary:dictionary];
                [commits addObject:commit];
            }
        }];
    }
    
    return commits;
}

#pragma mark - Initialize user interface

- (void)__initUserInterface {
    [self __initTableView];
    [self __initErrorLabel];
    [self __initTitle];
    [self __initLoadingIndicator];
    [self __dismissError];
    [self __updateRepositoryTitle];
    [self __updateCommitList];
    [self __updateLoadingIndicator];
}

- (void)__initTableView {
    self.tableView.accessibilityIdentifier = @"commitlist_list";
}

- (void)__initErrorLabel {
    self.errorLabel.accessibilityIdentifier = @"commitlist_no_commits_indicator";
}

- (void)__initTitle {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 30.0)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.accessibilityIdentifier = @"commitlist_title";
    self.navigationItem.titleView = self.titleLabel;
}

- (void)__initLoadingIndicator {
    [self.loadingActivityIndicatorView startAnimating];
    self.loadingActivityIndicatorView.accessibilityIdentifier = @"commit_list_loading_indicator";
}

#pragma mark - Update user interface

- (void)__updateUserInterface {
    [self __updateRepositoryTitle];
    [self __updateCommitList];
    [self __updateLoadingIndicator];
}

- (void)__updateRepositoryTitle {
    self.titleLabel.text = self.repositoryName;
}

- (void)__updateCommitList {
    [self.tableView reloadData];
}

- (void)__updateLoadingIndicator {
    self.loadingActivityIndicatorView.hidden = !self.isLoading;
}

- (void)__updateRepositoryIndicatorImageView {
    UIImage *image;
    NSString *accessibilityIdentifier;
    if (self.isPrivateRepository) {
        image = [UIImage imageNamed:@"icon_private"];
        accessibilityIdentifier = @"commit_list_repo_private";
    }
    else {
        image = [UIImage imageNamed:@"icon_public"];
        accessibilityIdentifier = @"commit_list_repo_public";
    }
    self.repositoryIndicatorImageView.image = image;
    self.repositoryIndicatorImageView.accessibilityIdentifier = accessibilityIdentifier;
}

#pragma mark - Error message

- (void)__presentErrorWithMessage:(NSString *)message {
    self.errorLabel.text = message;
}

- (void)__dismissError {
    self.errorLabel.text = nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    US2Commit *commit = [self.commits objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showCommitDetail" sender:commit];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    US2CommitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(US2CommitTableViewCell.class)];
    cell.accessibilityIdentifier = @"commit_list_list_row";
    
    US2Commit *commit = [self.commits objectAtIndex:indexPath.row];
    cell.nameString = commit.message;
    cell.dateString = commit.date;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:US2CommitDetailViewController.class]) {
        US2CommitDetailViewController *commitDetailViewController = segue.destinationViewController;
        if ([sender isKindOfClass:US2Commit.class]) {
            commitDetailViewController.commit = sender;
        }
    }
}

@end
