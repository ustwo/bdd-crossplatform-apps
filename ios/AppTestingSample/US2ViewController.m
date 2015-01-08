//
//  US2ViewController.m
//  AppTestingSample
//
//  Created by Martin on 08/01/2015.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

#import "US2ViewController.h"
#import "US2Commit.h"
#import "US2CommitTableViewCell.h"

@interface US2ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) IBOutlet UITableView *tableView;
@property (nonatomic, strong, readwrite) IBOutlet UIActivityIndicatorView *loadingActivityIndicatorView;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, strong, readwrite) NSData *urlData;
@property (nonatomic, strong, readwrite) NSArray *commits;
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
}

- (void)__updateData {
    [self __requestCommitsByRepositoryName:@"US2FormValidator" withCount:5];
}

- (void)__requestCommitsByRepositoryName:(NSString *)repositoryName withCount:(NSUInteger)count {
    self.isLoading = YES;
    [self __updateLoadingIndicator];
    
    NSString *londonWeatherUrl = @"https://api.github.com/repos/ustwo/#{respository_name}/commits?per_page=#{count}";
    londonWeatherUrl = [londonWeatherUrl stringByReplacingOccurrencesOfString:@"#{respository_name}" withString:repositoryName];
    londonWeatherUrl = [londonWeatherUrl stringByReplacingOccurrencesOfString:@"#{count}" withString:@(count).stringValue];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:londonWeatherUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.commits = [self __commitsFromJSONArray:jsonArray];
        self.isLoading = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __updateUserInterface];
        });
    }];
    [dataTask resume];
}

#pragma mark - User interface

- (void)__initUserInterface {
    [self __updateCommitList];
    [self __updateLoadingIndicator];
}

- (void)__updateUserInterface {
    [self __updateCommitList];
    [self __updateLoadingIndicator];
}

- (void)__updateCommitList {
    [self.tableView reloadData];
}

- (void)__updateLoadingIndicator {
    self.loadingActivityIndicatorView.hidden = !self.isLoading;
}

#pragma mark - Parsing

- (US2Commit *)__commitFromDictionary:(NSDictionary *)dictionary {
    US2Commit *commit = [[US2Commit alloc] init];
    
    id sha = [dictionary objectForKey:@"sha"];
    if ([sha isKindOfClass:NSString.class]) {
        commit.sha = sha;
    }
    
    id message = [dictionary objectForKey:@"message"];
    if ([message isKindOfClass:NSString.class]) {
        commit.message = message;
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

#pragma mark - Table data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    US2CommitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(US2CommitTableViewCell.class)];
    
    US2Commit *commit = [self.commits objectAtIndex:indexPath.row];
    cell.nameString = commit.message;
    cell.dateString = commit.sha;
    
    return cell;
}

@end
