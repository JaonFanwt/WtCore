//
//  WtDelegateProxy.h
//  WtCore
//
//  Created by wtfan on 2017/7/29.
//  Copyright © 2017年 wtfan(long). All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *wtExtractStructName(NSString *typeEncodeString);

@interface WtDelegateProxy : NSObject
- (instancetype)initWithProtocol:(Protocol *)protocol;
- (void)selector:(SEL)selector block:(id)block;
@end
