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
                 andMessage:(NSString *)message
                    andDate:(NSString *)date {
    
    self = [super init];
    if (self) {
        _sha = [sha copy];
        _message = [message copy];
        _date = [date copy];
    }
    
    return self;
}

@end
