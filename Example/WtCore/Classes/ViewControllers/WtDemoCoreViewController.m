//
//  WtDemoCoreViewController.m
//  WtCore
//
//  Created by wtfan on 2017/9/5.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

#import "WtDemoCoreViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <WtCore/WtCore.h>

#import "WtDemoCellModel.h"

@interface WtDemoCoreViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation WtDemoCoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"WtCore Library";
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
    
    {
        WtDemoCellModel *cellModel = [[WtDemoCellModel alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"NSURL扩展";
        cellModel.subTitle = @"wtRemoveParams:";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            
            NSURL *url = [NSURL URLWithString:@"https://www.google.co.jp/search?q=params&oQ=params&aqs=chrome..69i57j0l5.854j0j7&sourceid=chrome&iE=UTF-8"];
            NSURL *wrapURL = [url wtRemoveParams:@[@"Oq", @"sourceid"]];
            NSLog(@"[WtCore]URL before:%@", url);
            NSLog(@"[WtCore]URL after:%@", wrapURL);
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WtTableViewCellModel *cellModel = _datas[indexPath.row];
    [cellModel.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
