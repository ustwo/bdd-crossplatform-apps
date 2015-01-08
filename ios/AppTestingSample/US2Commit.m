//
//  US2Commit.m
//  AppTestingSample
//
//  Created by Martin on 08/01/2015.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

#import "US2Commit.h"

@implementation US2Commit

- (instancetype)initWithSha:(NSString *)sha
                    message:(NSString *)message {
    
    self = [super init];
    if (self) {
        _sha = [sha copy];
        _message = [message copy];
    }
    
    return self;
}

@end
