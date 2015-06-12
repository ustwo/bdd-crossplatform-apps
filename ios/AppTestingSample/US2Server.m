//
//  US2Server.m
//  AppTestingSample
//
//  Created by Martin on 12/01/2015.
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
    
    NSDictionary *serverDictionary = nil;
    if (filePath) {
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        serverDictionary = jsonObject[@"server"];
    }
    
    return serverDictionary;
}

@end
