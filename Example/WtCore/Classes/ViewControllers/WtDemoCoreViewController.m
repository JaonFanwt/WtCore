//
//  WtDemoCoreViewController.m
//  WtCore_Example
//
//  Created by wtfan on 2017/9/5.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

#import "WtDemoCoreViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <WtCore/WtCore.h>

#import "WtDemoCellGlue.h"

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
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
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
    
    {
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"NSURL扩展";
        cellModel.subTitle = @"wtSortedByCompareQueryComponents";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            
            NSURL *url = [NSURL URLWithString:@"https://www.google.co.jp/search?q=params&oQ=params&aqs=chrome..69i57j0l5.854j0j7&sourceid=chrome&iE=UTF-8"];
            NSURL *wrapURL = [url wtSortedByCompareQueryComponents];
            NSLog(@"[WtCore]URL before:%@", url);
            NSLog(@"[WtCore]URL after:%@", wrapURL);
        }];
    }
    
    {
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"wtDispatch_in_main";
        cellModel.subTitle = @"在主线程中执行block，不带参数";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            
            wtDispatch_in_main(^(){
                NSLog(@"[IsMainThread:%d]在主线程中执行block，不带参数", [NSThread isMainThread]);
            });
        }];
    }
    
    {
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"wtDispatch_in_main";
        cellModel.subTitle = @"在主线程中执行block，带参数（可变参数）";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            
            wtDispatch_in_main(^(NSString *str, int num, char c, CGRect frame, void (^block)()){
                NSLog(@"[IsMainThread:%d]在主线程中执行block，带参数（可变参数）", [NSThread isMainThread]);
                NSLog(@"str:%@, num:%d, frame:%@, char:%c", str, num, NSStringFromCGRect(frame), c);
                if (block) {
                    block();
                }
            }, @"String", 100, 'c', CGRectMake(0, 0, 100, 200), ^{
                NSLog(@"哈哈");
            });
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
