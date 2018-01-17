//
//  UIView+WtCutter.h
//  WtCore
//
//  Created by wtfan on 2017/12/26.
//

#import <UIKit/UIKit.h>

typedef enum {
    eWtFindPureSeparateLinePointDirectionDown = 0,
    eWtFindPureSeparateLinePointDirectionUp
}eWtFindPureSeparateLinePointDirection;

@interface UIView (WtCutter)
- (CGPoint)wt_findPureColorLineWithBeginAnchor:(CGPoint)point
                                         width:(CGFloat)width
                                      sliceNum:(int)sliceNum
                                     direction:(eWtFindPureSeparateLinePointDirection)direction;
- (CGPoint)wt_trimPureColorLineWithBeginAnchor:(CGPoint)point
                                         width:(CGFloat)width
                                      sliceNum:(int)sliceNum
                                     direction:(eWtFindPureSeparateLinePointDirection)direction;
@end
