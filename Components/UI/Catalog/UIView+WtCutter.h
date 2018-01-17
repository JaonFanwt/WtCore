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
- (CGPoint)wt_findPureSeparateLinePointWithAnchor:(CGPoint)point direction:(eWtFindPureSeparateLinePointDirection)direction;
@end
