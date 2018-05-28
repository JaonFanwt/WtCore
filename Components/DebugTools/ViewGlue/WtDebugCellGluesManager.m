//
//  WtDebugCellGluesManager.m
//  WtCore
//
//  Created by fanwt on 2017/12/29.
//

#import "WtDebugCellGluesManager.h"

#import <Masonry/Masonry.h>
#import <FLEX/FLEXManager.h>
#import <KMCGeigerCounter/KMCGeigerCounter.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtCore.h"
#import "WtDispatch.h"
#import "WtDebugShowFontsCellGlue.h"
#import "WtDebugTableViewCellRightDetailGlue.h"
#import "WtDebugTableViewCellBasicSwitchGlue.h"
#import "WtDebugShowFontsViewController.h"
#import "WtDebugSwitchNetworkViewController.h"
#import "UIView+WtExtension.h"

@implementation WtDebugCellGluesManager {
    NSMutableArray<WtCellGlue *> *_cellGlues;
}

+ (instancetype)shared {
    static WtDebugCellGluesManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WtDebugCellGluesManager alloc] init];
    });
    return manager;
}

- (void)setCellGlues:(NSMutableArray<WtCellGlue *> *)cellGlues {
    _cellGlues = cellGlues;
}

- (NSMutableArray<WtCellGlue *> *)cellGlues {
    if (!_cellGlues) {
        _cellGlues = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _cellGlues;
}

- (void)installDefault {
    static BOOL isInstallled;
    
    if (isInstallled) return;
    
    isInstallled = YES;
    {   // Switch network
        WtDebugTableViewCellRightDetailGlue *cellGlue = [[WtDebugTableViewCellRightDetailGlue alloc] init];
        [self.cellGlues addObject:cellGlue];
        
        cellGlue.name = @"切换网络";
        [cellGlue.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            WtDebugSwitchNetworkViewController *toViewCtrl = [[WtDebugSwitchNetworkViewController alloc] init];
            [tableView.wtFirstViewController.navigationController pushViewController:toViewCtrl animated:YES];
        }];
    }
    
    {   // FLEX
        WtDebugTableViewCellRightDetailGlue *cellGlue = [[WtDebugTableViewCellRightDetailGlue alloc] init];
        [self.cellGlues addObject:cellGlue];
        
        cellGlue.name = @"FLEX";
        cellGlue.detailDescription = @"辅助工具";
        
        [cellGlue.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[FLEXManager sharedManager] showExplorer];
        }];
    }
    
    {   // FPS
        WtDebugTableViewCellBasicSwitchGlue *cellGlue = [[WtDebugTableViewCellBasicSwitchGlue alloc] init];
        [self.cellGlues addObject:cellGlue];
        
        cellGlue.name = @"FPS";
        cellGlue.detailDescription = @"检测FPS，显示在状态栏当中";
        cellGlue.switchOn = [KMCGeigerCounter sharedGeigerCounter].enabled;
        
        [[RACObserve(cellGlue, switchOn) takeUntil:[cellGlue rac_willDeallocSignal]] subscribeNext:^(id x) {
            [KMCGeigerCounter sharedGeigerCounter].enabled = [x boolValue];
        }];
    }
    
    {
        // Fonts
        WtDebugTableViewCellRightDetailGlue *cellModel = [[WtDebugTableViewCellRightDetailGlue alloc] init];
        [self.cellGlues addObject:cellModel];
        
        cellModel.name = @"Fonts";
        cellModel.detailDescription = @"展示所有字体";
        
        [cellModel.tableViewDelegate selector:@selector(tableView:didSelectRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            WtDebugShowFontsViewController *toViewCtrl = [[WtDebugShowFontsViewController alloc] init];
            [tableView.wtFirstViewController.navigationController pushViewController:toViewCtrl animated:YES];
        }];
    }
}
@end
