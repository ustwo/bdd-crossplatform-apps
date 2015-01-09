//
//  US2CommitDetailViewController.h
//  AppTestingSample
//
//  Created by Martin on 09/01/2015.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class US2Commit;

@interface US2CommitDetailViewController : UIViewController

- (instancetype)initWithCommit:(US2Commit *)commit;

@property (nonatomic, strong, readwrite) US2Commit *commit;

@end
