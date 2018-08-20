//
//  UIViewController+WtObserver.h
//  WtObserver
//
//  Created by wtfan on 2017/8/16.
//
//

#import <UIKit/UIKit.h>


@interface UIViewController (WtObserver)
@property (nonatomic, readonly) NSTimeInterval startInitTime;
@property (nonatomic, readonly) NSTimeInterval startViewDidLoadTime;
@property (nonatomic, readonly) NSTimeInterval endViewDidLoadTime;
@property (nonatomic, readonly) NSTimeInterval startViewWillAppearTime;
@property (nonatomic, readonly) NSTimeInterval endViewWillAppearTime;
@property (nonatomic, readonly) NSTimeInterval startViewDidAppearTime;
@property (nonatomic, readonly) NSTimeInterval endViewDidAppearTime;
@end
