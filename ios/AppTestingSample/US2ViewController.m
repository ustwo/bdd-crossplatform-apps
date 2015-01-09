//
//  US2ViewController.m
//  AppTestingSample
//
//  Created by Martin on 08/01/2015.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

#import "US2ViewController.h"

// Model
#import "US2Commit.h"

// View
#import "US2CommitTableViewCell.h"

// Controller
#import "US2CommitDetailViewController.h"

@interface US2ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView *loadingActivityIndicatorView;
@property (nonatomic, strong, readwrite) IBOutlet UILabel *errorLabel;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, strong, readwrite) NSData *urlData;
@property (nonatomic, strong, readwrite) NSArray *commits;
@property (nonatomic, strong, readwrite) NSString *repositoryName;
@property (nonatomic, strong, readwrite) NSDateFormatter *dateFormatter;
@end

@implementation US2ViewController

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
    self.repositoryName = @"US2FormValidator";
}

- (void)__updateData {
    [self __requestCommitsByRepositoryName:@"US2FormValidator" withCount:20];
}

- (void)__requestCommitsByRepositoryName:(NSString *)repositoryName withCount:(NSUInteger)count {
    self.isLoading = YES;
    [self __updateLoadingIndicator];
    
    NSString *url = @"https://api.github.com/repos/ustwo/#{respository_name}/commits?per_page=#{count}";
    url = [url stringByReplacingOccurrencesOfString:@"#{respository_name}" withString:repositoryName];
    url = [url stringByReplacingOccurrencesOfString:@"#{count}" withString:@(count).stringValue];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.isLoading = NO;
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *errorMessage = @"Could not load commits";
                [self __presentErrorWithMessage:errorMessage];
            });
        }
        else {
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (jsonArray == nil ||
                jsonArray.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *errorMessage = @"No commits available";
                    [self __presentErrorWithMessage:errorMessage];
                });
                
                self.commits = [@[] mutableCopy];
            }
            else {
                self.commits = [self __commitsFromJSONArray:jsonArray];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __updateUserInterface];
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
                commit.date = [self.dateFormatter dateFromString:date];
            }
        }
    }
    
    return commit;
}

- (NSArray *)__commitsFromJSONArray:(NSArray *)array {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    
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

#pragma mark - User interface

- (void)__initUserInterface {
    [self __initTableView];
    [self __initErrorLabel];
    [self __initLoadingIndicator];
    [self __dismissError];
    [self __updateRepositoryTitle];
    [self __updateCommitList];
    [self __updateLoadingIndicator];
}

- (void)__initTableView {
    self.tableView.accessibilityIdentifier = @"commit-list.list";
}

- (void)__initErrorLabel {
    self.errorLabel.accessibilityIdentifier = @"commit-list.error-label";
}

- (void)__initLoadingIndicator {
    self.loadingActivityIndicatorView.accessibilityIdentifier = @"commit-list.loading-indicator";
}

- (void)__updateUserInterface {
    [self __updateRepositoryTitle];
    [self __updateCommitList];
    [self __updateLoadingIndicator];
}

- (void)__updateRepositoryTitle {
    self.title = self.repositoryName;
}

- (void)__updateCommitList {
    [self.tableView reloadData];
}

- (void)__updateLoadingIndicator {
    self.loadingActivityIndicatorView.hidden = !self.isLoading;
}

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
    
    US2Commit *commit = [self.commits objectAtIndex:indexPath.row];
    cell.nameString = commit.message;
    cell.dateString = [self.dateFormatter stringFromDate:commit.date];
    
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
