//
//  WtDemoWebViewController.m
//  WtCore_Example
//
//  Created by wtfan on 2017/9/1.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

#import "WtDemoWebViewController.h"

#import <WtCore/WtThunderWeb.h>
#import <WtCore/WtCore.h>
#import <WtCore/WtObserver.h>


@interface WtDemoWebViewController () <UIWebViewDelegate>
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
    request = [wtThunderConsumeWebRequest([NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/"]], @"1") mutableCopy];
    [request setValue:[NSString stringWithFormat:@"%.0f", self.startInitTime * 1000] forHTTPHeaderField:WtThunderHeaderKeyContainerInitTime];
  } else {
    request = [[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/"]] mutableCopy];
  }

  [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  _webView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  _webView.delegate = self;
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
