//
//  WtDebugToolsViewController.m
//  WtDebugTools
//
//  Created by wtfan on 2017/5/10.
//
//

#import "WtDebugToolsViewController.h"

#import <Masonry/Masonry.h>
#import <FLEX/FLEXManager.h>
#import <KMCGeigerCounter/KMCGeigerCounter.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtCellGlue.h"

#import "WtDebugTableViewCellBasicSwitchGlue.h"
#import "WtDebugTableViewCellRightDetailGlue.h"
#import "WtDebugSwitchNetworkViewController.h"
#import "WtDebugTableViewCellBasicSwitch.h"

@interface WtDebugToolsViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;
@end

@implementation WtDebugToolsViewController
- (void)loadView {
    [super loadView];
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create datas 
- (void)createDatas {
    NSMutableArray *models = @[].mutableCopy;
    
    {   // Switch network
        WtDebugTableViewCellRightDetailGlue *cellModel = [[WtDebugTableViewCellRightDetailGlue alloc] init];
        cellModel.name = @"切换网络";
        [models addObject:cellModel];
        @weakify(self);
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            WtDebugSwitchNetworkViewController *toViewCtrl = [[WtDebugSwitchNetworkViewController alloc] init];
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
    }
    
    {   // FLEX
        WtDebugTableViewCellRightDetailGlue *cellModel = [[WtDebugTableViewCellRightDetailGlue alloc] init];
        cellModel.name = @"FLEX";
        cellModel.detailDescription = @"辅助工具";
        
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[FLEXManager sharedManager] showExplorer];
        }];
        
        [models addObject:cellModel];
    }
    
    {   // FPS
        WtDebugTableViewCellBasicSwitchGlue *cellModel = [[WtDebugTableViewCellBasicSwitchGlue alloc] init];
        cellModel.name = @"FPS";
        cellModel.detailDescription = @"检测FPS，显示在状态栏当中";
        cellModel.on = [KMCGeigerCounter sharedGeigerCounter].enabled;
        
        [[RACObserve(cellModel, on) takeUntil:[cellModel rac_willDeallocSignal]] subscribeNext:^(id x) {
            [KMCGeigerCounter sharedGeigerCounter].enabled = [x boolValue];
        }];
        
        [models addObject:cellModel];
    }

    self.datas = models;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellModel = _datas[indexPath.row];
    return [cellModel.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellModel = _datas[indexPath.row];
    CGFloat height = [cellModel.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellModel = _datas[indexPath.row];
    [cellModel.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end
