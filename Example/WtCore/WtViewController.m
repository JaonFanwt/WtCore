//
//  WtViewController.m
//  WtCore_Example
//
//  Created by JaonFanwt on 08/16/2017.
//  Copyright (c) 2017 JaonFanwt. All rights reserved.
//

#import "WtViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <WtCore/WtCore.h>
#import <WtCore/WtDebugTools.h>
#import <WtCore/WtThunderWeb.h>
#import <WtCore/WtUI.h>

#import "WtDemoCellGlue.h"

@interface WtViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation WtViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"WtCore Library";
    
    [NSURLProtocol registerClass:[WtThunderURLProtocol class]];
    
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
    
    void (^previewingToCommitBlock)(id <UIViewControllerPreviewing> previewingContext, UIViewController *viewControllerToCommit) = ^(id <UIViewControllerPreviewing> previewingContext, UIViewController *viewControllerToCommit){
        UIViewController *firstViewCtrl = [previewingContext.sourceView wtFirstViewController];
        [firstViewCtrl.navigationController pushViewController:viewControllerToCommit animated:YES];
    };
    
    @weakify(self);
    {// DelegateProxy
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"WtDelegateProxy";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            Class cls = WTClassFromString(@"WtDemoDelegateProxyViewController");
            if (!cls) return;
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoDelegateProxyViewController" bundle:nil];
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:viewControllerForLocation:) block:^(id <UIViewControllerPreviewing> previewingContext, CGPoint location){
            Class cls = WTClassFromString(@"WtDemoDelegateProxyViewController");
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoDelegateProxyViewController" bundle:nil];
            return toViewCtrl;
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:commitViewController:) block:[previewingToCommitBlock copy]];
    }
    
    {// Core
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"WtCore";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            Class cls = WTClassFromString(@"WtDemoCoreViewController");
            if (!cls) return;
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoCoreViewController" bundle:nil];
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:viewControllerForLocation:) block:^(id <UIViewControllerPreviewing> previewingContext, CGPoint location){
            Class cls = WTClassFromString(@"WtDemoCoreViewController");
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoCoreViewController" bundle:nil];
            return toViewCtrl;
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:commitViewController:) block:[previewingToCommitBlock copy]];
    }
    
    {// UI
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"WtUI";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            Class cls = WTClassFromString(@"WtDemoUIViewController");
            if (!cls) return;
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoUIViewController" bundle:nil];
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:viewControllerForLocation:) block:^(id <UIViewControllerPreviewing> previewingContext, CGPoint location){
            Class cls = WTClassFromString(@"WtDemoUIViewController");
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoUIViewController" bundle:nil];
            return toViewCtrl;
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:commitViewController:) block:[previewingToCommitBlock copy]];
    }
    
    {// DebugTools
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"DebugTools";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            Class cls = WTClassFromString(@"WtDebugToolsViewController");
            if (!cls) return;
            UIViewController *toViewCtrl = [[cls alloc] init];
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
        
        // 设置切换接口数据
        [WtDebugSwitchNetworkManager sharedManager].initialNetworkGroupsIfNecessary = ^NSArray<WtDebugSwitchNetworkGroup *> *{
            NSMutableArray *result = @[].mutableCopy;
            
            { // 数据接口
                WtDebugSwitchNetworkGroup *group = [[WtDebugSwitchNetworkGroup alloc] init];
                group.key = @"DataInterface";
                group.name = @"数据接口";
                [result addObject:group];
                
                WtDebugSwitchNetworkItem *model = [[WtDebugSwitchNetworkItem alloc] init];
                model.urlString = @"https://www.data.com";
                model.urlDescription = @"正式地址";
                
                [group addModel:model];
                [group selectModel:model];
                
                model = [[WtDebugSwitchNetworkItem alloc] init];
                model.urlString = @"https://www.dataTest.com";
                model.urlDescription = @"测试地址";
                
                [group addModel:model];
            }
            { // 登录接口
                WtDebugSwitchNetworkGroup *group = [[WtDebugSwitchNetworkGroup alloc] init];
                group.key = @"LoginInterface";
                group.name = @"登录接口";
                [result addObject:group];
                
                WtDebugSwitchNetworkItem *model = [[WtDebugSwitchNetworkItem alloc] init];
                model.urlString = @"https://www.login.com";
                model.urlDescription = @"正式地址";
                
                [group addModel:model];
                
                model = [[WtDebugSwitchNetworkItem alloc] init];
                model.urlString = @"https://www.loginTest.com";
                model.urlDescription = @"测试地址";
                
                [group addModel:model];
                [group selectModel:model];
            }
            { // Web接口
                WtDebugSwitchNetworkGroup *group = [[WtDebugSwitchNetworkGroup alloc] init];
                group.key = @"WebInterface";
                group.name = @"Web接口";
                [result addObject:group];
                
                WtDebugSwitchNetworkItem *model = [[WtDebugSwitchNetworkItem alloc] init];
                model.urlString = @"https://www.web.com";
                model.urlDescription = @"正式地址";
                
                [group addModel:model];
                [group selectModel:model];
                
                model = [[WtDebugSwitchNetworkItem alloc] init];
                model.urlString = @"https://www.webTest.com";
                model.urlDescription = @"测试地址";
                
                [group addModel:model];
            }
            
            return result;
        };
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:viewControllerForLocation:) block:^(id <UIViewControllerPreviewing> previewingContext, CGPoint location){
            Class cls = WTClassFromString(@"WtDebugToolsViewController");
            UIViewController *toViewCtrl = [[cls alloc] init];
            return toViewCtrl;
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:commitViewController:) block:[previewingToCommitBlock copy]];
    }
    
    {// Observer
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"WtObserver";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            Class cls = WTClassFromString(@"WtDemoObserverViewController");
            if (!cls) return;
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoObserverViewController" bundle:nil];
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:viewControllerForLocation:) block:^(id <UIViewControllerPreviewing> previewingContext, CGPoint location){
            Class cls = WTClassFromString(@"WtDemoObserverViewController");
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoObserverViewController" bundle:nil];
            return toViewCtrl;
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:commitViewController:) block:[previewingToCommitBlock copy]];
    }
    
    {// ThunderWeb
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"WtThunderWeb";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            Class cls = WTClassFromString(@"WtDemoThunderWebViewController");
            if (!cls) return;
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoThunderWebViewController" bundle:nil];
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:viewControllerForLocation:) block:^(id <UIViewControllerPreviewing> previewingContext, CGPoint location){
            Class cls = WTClassFromString(@"WtDemoThunderWebViewController");
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoThunderWebViewController" bundle:nil];
            return toViewCtrl;
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:commitViewController:) block:[previewingToCommitBlock copy]];
    }
    
    {// Wattpad
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"WtWattpadView";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            Class cls = WTClassFromString(@"WtDemoWattpadViewController");
            if (!cls) return;
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoWattpadViewController" bundle:nil];
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:viewControllerForLocation:) block:^(id <UIViewControllerPreviewing> previewingContext, CGPoint location){
            Class cls = WTClassFromString(@"WtDemoWattpadViewController");
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoWattpadViewController" bundle:nil];
            return toViewCtrl;
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:commitViewController:) block:[previewingToCommitBlock copy]];
    }
    
    {// WindowAlert
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"WtWindowAlert";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            Class cls = WTClassFromString(@"WtDemoWattpadViewController");
            if (!cls) return;
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoWattpadViewController" bundle:nil];
            @weakify(toViewCtrl);
            [toViewCtrl wtShowWithCompletion:^(BOOL finished){
                @strongify(toViewCtrl);
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, 0, 40, 30);
                button.backgroundColor = [UIColor clearColor];
                button.titleLabel.font = [UIFont systemFontOfSize:16];
                [button setTitle:@"关闭" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
                
                @weakify(toViewCtrl);
                [button wtAction:^(UIControl *control, UIControlEvents controlEvents) {
                    @strongify(toViewCtrl);
                    [toViewCtrl wtCloseWithCompletion:nil];
                } forControlEvents:UIControlEventTouchUpInside];
                
                toViewCtrl.navigationItem.leftBarButtonItem = buttonItem;
            } navigationBarHidden:NO];
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:viewControllerForLocation:) block:^(id <UIViewControllerPreviewing> previewingContext, CGPoint location){
            Class cls = WTClassFromString(@"WtDemoWattpadViewController");
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoWattpadViewController" bundle:nil];
            return toViewCtrl;
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:commitViewController:) block:[previewingToCommitBlock copy]];
    }
    
    {// ViewGlue on Swift
        WtDemoCellGlue *cellModel = [[WtDemoCellGlue alloc] init];
        [_datas addObject:cellModel];
        cellModel.title = @"ViewGlue on Swift";
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            @strongify(self);
            Class cls = WTClassFromString(@"WtDemoViewGlueController");
            if (!cls) return;
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoViewGlueController" bundle:nil];
            [self.navigationController pushViewController:toViewCtrl animated:YES];
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:viewControllerForLocation:) block:^(id <UIViewControllerPreviewing> previewingContext, CGPoint location){
            Class cls = WTClassFromString(@"WtDemoViewGlueController");
            UIViewController *toViewCtrl = [[cls alloc] initWithNibName:@"WtDemoViewGlueController" bundle:nil];
            return toViewCtrl;
        }];
        
        [cellModel.previewingDelegate selector:@selector(previewingContext:commitViewController:) block:[previewingToCommitBlock copy]];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellModel = _datas[indexPath.row];
    
    UITableViewCell *cell = [cellModel.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([[UIDevice currentDevice] wtEqualOrGreaterThan:9]) {
        [self registerForPreviewingWithDelegate:cellModel.previewingDelegate sourceView:cell];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellModel = _datas[indexPath.row];
    return [cellModel.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WtCellGlue *cellModel = _datas[indexPath.row];
    
    [cellModel.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end
