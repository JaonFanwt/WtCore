//
//  WtDemoUIViewController.m
//  WtCore_Example
//
//  Created by wtfan on 2017/9/8.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

#import "WtDemoUIViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <WtCore/WtCore.h>
#import <WtCore/WtUI.h>

#import "WtDemoCellGlue.h"

@interface WtDemoUIViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation WtDemoUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"WtUI Library";
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
        cellModel.title = @"UIAlertView-WtExtension";
        cellModel.subTitle = @"Use the WtDelegateProxy proxy delegate.";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"UIAlertView-WtExtension" message:@"Use the WtDelegateProxy proxy delegate." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alertView.wtDelegateProxy selector:@selector(alertView:clickedButtonAtIndex:) block:^(UIAlertView *alertView, NSInteger index){
                UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Tip" message:[NSString stringWithFormat:@"ClickedButtonAtIndex %zd", index] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [v show];
            }];
            [alertView show];
        }];
    }
    
    {
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"UIButton";
        cellModel.subTitle = @"Use the WtDelegateProxy proxy delegate.";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button wtAction:^(UIControl *control, UIControlEvents controlEvents) {
                NSLog(@"%s - %@ - %zd", __func__, control, controlEvents);
            } forControlEvents:UIControlEventTouchUpInside];
            
            [button wtAction:^(UIControl *control, UIControlEvents controlEvents) {
                NSLog(@"%s - %@ - %zd", __func__, control, controlEvents);
            } forControlEvents:UIControlEventTouchDragInside];
            
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            [button sendActionsForControlEvents:UIControlEventTouchDragInside];
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
