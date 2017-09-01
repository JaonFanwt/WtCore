//
//  UIWebView+WtObserver.h
//  Pods
//
//  Created by wtfan on 2017/8/16.
//
//

#import <UIKit/UIKit.h>

@interface UIWebView (WtObserver)
@property (nonatomic, readonly) NSTimeInterval startInitTime;
@property (nonatomic, readonly) NSTimeInterval startDidStartLoadTime;
@property (nonatomic, readonly) NSTimeInterval endDidStartLoadTime;
@property (nonatomic, readonly) NSTimeInterval startLoadRequestTime;
@property (nonatomic, readonly) NSTimeInterval endLoadRequestTime;
@property (nonatomic, readonly) NSTimeInterval startDidFinishLoadTime;
@property (nonatomic, readonly) NSTimeInterval endDidFinishLoadTime;
@end
