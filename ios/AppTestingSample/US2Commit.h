//
//  US2Commit.h
//  AppTestingSample
//
//  Created by Martin on 08/01/2015.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface US2Commit : NSObject

- (instancetype)initWithSha:(NSString *)sha
                 andMessage:(NSString *)message
                    andDate:(NSDate *)date;

@property (nonatomic, copy, readwrite) NSString *sha;
@property (nonatomic, copy, readwrite) NSString *message;
@property (nonatomic, copy, readwrite) NSDate *date;

@end
