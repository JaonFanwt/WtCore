//
//  WtThunderURLSessionManager.h
//  WtThunderWeb
//
//  Created by wtfan on 2017/9/12.
//

#import <Foundation/Foundation.h>

#import "WtURLSessionManagerTaskDelegate.h"


@interface WtThunderURLSessionManager : NSObject <NSURLSessionDelegate, NSURLSessionDataDelegate>
+ (instancetype)shared;
- (NSURLSessionTask *)wtTaskWithRequest:(NSURLRequest *)request
                               delegate:(WtURLSessionManagerTaskDelegate *)delegate;
@end
