//
//  WtWindow.h
//  WtUI
//
//  Created by wtfan on 2017/10/31.
//

#import <UIKit/UIKit.h>

#import "WtWindowAlert.h"


@interface WtWindow : UIWindow
@property (nonatomic, weak) WtWindowAlert *windowAlert;
- (void)wtCloseWithCompletion:(void (^)(BOOL finished))completion;
- (void)wtCustomCloseWithCompletion:(void (^)(BOOL finished))completion;
@end
