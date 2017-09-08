//
//  WtDemoWebViewController.m
//  WtCore
//
//  Created by wtfan on 2017/9/1.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

#import "WtDemoWebViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <WtCore/WtThunderWeb.h>
#import <WtCore/WtCore.h>
#import <WtCore/WtObserver.h>

@interface WtDemoWebViewController ()
<UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation WtDemoWebViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableURLRequest *request = nil;
    if (_useThunder) {
        request = [wtThunderConsumeWebRequest([NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.qidian.com/"]], @"1") mutableCopy];
        [request setValue:[NSString stringWithFormat:@"%.0f", self.startInitTime * 1000] forHTTPHeaderField:WtThunderHeaderKeyContainerInitTime];
    }else {
        request = [[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.qidian.com/"]] mutableCopy];
    }
    
    NSString *t = [NSString stringWithFormat:@"%.0f", ([[NSDate date] timeIntervalSince1970] - self.startInitTime) * 1000];
    NSLog(@"[Glean Web BI]From the viewController initialization to start the webView request takes %@ms", t);
    [[WtObserveDataGleaner shared] glean:@"https://www.qidian.com" columnName:@"VC initialization to start webView request" value:t error:nil];
    
    [self.webView loadRequest:request];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
