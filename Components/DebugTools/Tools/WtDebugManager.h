//
//  WtDebugManager.h
//  Pods
//
//  Created by wtfan on 2017/9/11.
//
//

#import <Foundation/Foundation.h>

@interface WtDebugManager : NSObject
@property (nonatomic, assign) BOOL isDebugOn;
+ (instancetype)shared;
@end
