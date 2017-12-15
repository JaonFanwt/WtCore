//
//  WtDemoThunderWebViewController.m
//  WtCore_Example
//
//  Created by wtfan on 2017/9/1.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

#import "WtDemoThunderWebViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <WtCore/WtCore.h>
#import <WtCore/WtObserver.h>
#import <WtCore/WtThunderWeb.h>

#import "WtDemoCellGlue.h"
#import "WtDemoWebViewController.h"

@interface WtDemoThunderWebViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation WtDemoThunderWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"WtThunderWeb Library";
    [self createDatas];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createDatas {
    _datas = @[].mutableCopy;
    
    @weakify(self);
    {
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"Load without thunder";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            WtDemoWebViewController *toViewCtrl = [[WtDemoWebViewController alloc] initWithNibName:@"WtDemoWebViewController" bundle:nil];
            toViewCtrl.useThunder = NO;
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
    }
    {
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"Load with thunder";
        cellModel.subTitle = @"Pre-session request";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            // 预载，以及测试请求合并
            for (NSInteger i = 0; i < 10; i++) {
                NSDate *date = [NSDate date];
                NSTimeInterval beginTime = [date timeIntervalSince1970];
                NSMutableURLRequest *request = [wtThunderProduceWebRequest([NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.qidian.com/"]], @"1") mutableCopy];
                [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    NSDate *date = [NSDate date];
                    NSTimeInterval endTime = [date timeIntervalSince1970];
                    
                    NSString *t = [NSString stringWithFormat:@"%.0f", (endTime - beginTime)*1000];
                    NSLog(@"[Glean Web BI]Pre-session request takes %@ms", t);
                }] resume];
            }
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            WtDemoWebViewController *toViewCtrl = [[WtDemoWebViewController alloc] initWithNibName:@"WtDemoWebViewController" bundle:nil];
            toViewCtrl.useThunder = YES;
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtTableViewCellModel *cellModel = _datas[indexPath.row];
    return [cellModel.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtTableViewCellModel *cellModel = _datas[indexPath.row];
    return [cellModel.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WtTableViewCellModel *cellModel = _datas[indexPath.row];
    [cellModel.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
