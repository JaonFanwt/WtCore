//
//  WtDemoObserverViewController.m
//  WtCore_Example
//
//  Created by wtfan on 2017/9/1.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

#import "WtDemoObserverViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <WtCore/WtCore.h>
#import <WtCore/WtObserver.h>

#import "WtDemoCellGlue.h"

@interface WtDemoObserverViewController ()
<UITableViewDelegate, UITableViewDataSource,
UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation WtDemoObserverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"WtObserver Library";
    [self createDatas];
    [self createActions];
    [self.tableView reloadData];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createDatas {
    _datas = @[].mutableCopy;
    
    {
        WtDemoCellGlue *cellGlue = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellGlue];
        cellGlue.title = @"缓存BI数据";
        [cellGlue.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            NSString *filePath = [[WtObserveDataGleaner shared] cacheToDisk];
            NSLog(@"[WtObserver]数据已缓存到磁盘:%@", filePath);
        }];
    }
    
    {
        WtDemoCellGlue *cellGlue = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellGlue];
        cellGlue.title = @"导出BI数据";
        [cellGlue.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            NSString *filePath = [WtObserveDataWritter toCSV:[WtObserveDataGleaner shared].treasures.allValues];
            NSLog(@"[WtObserver]数据已导出到磁盘:%@", filePath);
        }];
    }
}

- (void)createActions {
    @weakify(self);
    
    [[RACObserve(self, endViewDidLoadTime) takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
        @strongify(self);
        NSInteger time = (NSInteger)(([x doubleValue] - self.startInitTime) * 1000);
        NSLog(@"[WtObserver]Init到ViewDidLoad耗时: %zdms", time);
        [[WtObserveDataGleaner shared] glean:@"Web BI" columnName:@"ViewDidLoad" value:@(time) error:nil];
    }];
    
    [[[RACObserve(_webView, endLoadRequestTime) skip:1] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
        @strongify(self);
        NSInteger time = (NSInteger)(([x doubleValue] - self.startInitTime) * 1000);
        NSLog(@"[WtObserver]Init到LoadRequest耗时: %zdms", time);
        [[WtObserveDataGleaner shared] glean:@"Web BI" columnName:@"WebViewLoad" value:@(time) error:nil];
    }];
    
    [[[RACObserve(_webView, endDidStartLoadTime) skip:1] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
        @strongify(self);
        NSInteger time = (NSInteger)(([x doubleValue] - self.startInitTime) * 1000);
        NSLog(@"[WtObserver]Init到DidStartLoad耗时: %zdms", time);
        [[WtObserveDataGleaner shared] glean:@"Web BI" columnName:@"WebViewStartLoad" value:@(time) error:nil];
    }];
    
    [[[RACObserve(_webView, endDidFinishLoadTime) skip:1] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
        @strongify(self);
        NSInteger time = (NSInteger)(([x doubleValue] - self.startInitTime) * 1000);
        NSLog(@"[WtObserver]Init到DidFinishLoad耗时: %zdms", time);
        [[WtObserveDataGleaner shared] glean:@"Web BI" columnName:@"WebViewFinishLoad" value:@(time) error:nil];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellGlue = _datas[indexPath.row];
    return [cellGlue.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellGlue = _datas[indexPath.row];
    return [cellGlue.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WtCellGlue *cellGlue = _datas[indexPath.row];
    [cellGlue.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
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
