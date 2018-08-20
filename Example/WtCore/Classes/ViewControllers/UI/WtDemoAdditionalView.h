//
//  WtDemoAdditionalView.h
//  WtCore_Example
//
//  Created by fanwt on 21/01/2018.
//  Copyright © 2018 JaonFanwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@import WtCore;


@interface WtDemoAdditionalView : UIView
+ (WtFindPureColorPoint *)pureColorPoint;
- (instancetype)initWithCellGlues:(NSArray *)glues;
- (void)reloadDone:(void (^)(void))block;
@end
