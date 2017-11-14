//
//  WtObserveDataWritter.h
//  WtObserver
//
//  Created by wtfan on 2017/8/24.
//
//

#import <Foundation/Foundation.h>

#import "WtObserveData.h"

@interface WtObserveDataWritter : NSObject
+ (NSString *)path;
+ (NSString *)toCSV:(NSArray<WtObserveData *> *)observeDatas;
+ (void)clean;
@end
