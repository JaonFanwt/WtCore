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

@interface WtFindPureColorPoint : NSObject
@property (nonatomic, assign) CGFloat beginX;
@property (nonatomic, assign) CGFloat endX;
@end

@protocol WtViewCutterProtocol
@property (nonatomic, readonly) WtFindPureColorPoint *findPureColorPoint;
@end

@interface UIView (WtCutter)
- (CGPoint)wt_findPureColorLineWithBeginAnchor:(CGPoint)point
                                         length:(CGFloat)length
                                      sliceNum:(int)sliceNum
                                     direction:(eWtFindPureSeparateLinePointDirection)direction;
- (CGPoint)wt_trimPureColorLineWithBeginAnchor:(CGPoint)point
                                         length:(CGFloat)length
                                      sliceNum:(int)sliceNum
                                     direction:(eWtFindPureSeparateLinePointDirection)direction;
@end
