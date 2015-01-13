//
//  US2Server.m
//  AppTestingSample
//
//  Created by Martin on 12/01/2015.
//  Copyright (c) 2015 ustwo. All rights reserved.
//

#import "US2Server.h"

static NSString *const US2DefaultServerScheme = @"https";
static NSString *const US2DefaultServerHost = @"api.github.com";
static const NSUInteger US2DefaultServerPort = 0;

@implementation US2Server

+ (NSString *)scheme {
    NSDictionary *serverDictionary = [US2Server serverDictionary];
    NSString *serverScheme = serverDictionary[@"scheme"];
    
    if (serverScheme == nil ||
        serverScheme.length == 0) {
        serverScheme = US2DefaultServerScheme;
    }
    
    return serverScheme;
}

+ (NSString *)host {
    NSDictionary *serverDictionary = [US2Server serverDictionary];
    NSString *serverHost = serverDictionary[@"host"];
    
    if (serverHost == nil ||
        serverHost.length == 0) {
        serverHost = US2DefaultServerHost;
    }
    
    return serverHost;
}

+ (NSNumber *)port {
    NSDictionary *serverDictionary = [US2Server serverDictionary];
    NSNumber *serverPort = serverDictionary[@"port"];
    
    if (serverPort == nil &&
        US2DefaultServerPort > 0) {
        serverPort = @(US2DefaultServerPort);
    }
    
    return serverPort;
}

+ (NSDictionary *)serverDictionary {
    NSString *jsonFileName = @"server";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *serverDictionary = jsonObject[@"server"];
    return serverDictionary;
}

@end
