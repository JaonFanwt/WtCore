//
//  UIView+WtUI.h
//  WtCore
//
//  Created by wtfan on 2018/1/7.
//

#import <UIKit/UIKit.h>

#import "WtDelegateProxy.h"

@interface UIView (WtUI)
@property (nonatomic, assign) CGFloat wtX;
@property (nonatomic, assign, readonly) CGFloat wtMinX;
@property (nonatomic, assign, readonly) CGFloat wtMidX;
@property (nonatomic, assign, readonly) CGFloat wtMaxX;
@property (nonatomic, assign) CGFloat wtY;
@property (nonatomic, assign, readonly) CGFloat wtMinY;
@property (nonatomic, assign, readonly) CGFloat wtMidY;
@property (nonatomic, assign, readonly) CGFloat wtMaxY;
@property (nonatomic, assign) CGFloat wtWidth;
@property (nonatomic, assign) CGFloat wtHeight;
- (void)wtWhenTapped:(void (^)(void))block;
/**
 *  The return value (UInt8 *) requires the user to release after use.
 */
- (UInt8 *)bitdataWithFrame:(CGRect)frame scale:(CGFloat)scale;
@end
