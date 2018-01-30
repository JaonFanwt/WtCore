//
//  WtDemoUICutterViewController.m
//  WtCore_Example
//
//  Created by wtfan on 2018/1/18.
//  Copyright © 2018年 JaonFanwt. All rights reserved.
//

#import "WtDemoUICutterViewController.h"

#import "WtDemoAdditionalView.h"
#import "WtDemoAdditionalViewGlue.h"

@interface WtDemoCutterAdditionGlue : WtCellGlue
@property (nonatomic, strong) UIView *additionalView;
@end

@implementation WtDemoCutterAdditionGlue
- (instancetype)init {
    if (self = [super init]) {
        [self createActions];
    }
    return self;
}

- (void)createActions {
    @weakify(self);
    [self.tableViewDataSource selector:@selector(tableView:cellForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
        @strongify(self);
        static NSString *identifier = @"WtDemoCutterAdditionCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        for (UIView *v in cell.contentView.subviews) {
            [v removeFromSuperview];
        }
        [cell.contentView addSubview:self.additionalView];
        return cell;
    }];
    
    [self.tableViewDelegate selector:@selector(tableView:heightForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
        @strongify(self);
        return CGRectGetHeight(self.additionalView.frame);
    }];
}
@end

@interface WtDemoUICutterViewController ()
@property (nonatomic, strong) WtDemoAdditionalView *additionalView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *glues;
@property (nonatomic, strong) NSArray *toYs;
@end

@implementation WtDemoUICutterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.toYs = @[@60,
                  @132,
                  @189.6666666666667,
                  @251.3333333333333,
                  @298,
                  @360,
                  @399];
    
    [self createAdditionalView];
}

- (void)createAdditionalView {
    WtDemoAdditionalViewCellGlue *adViewGlue = [[WtDemoAdditionalViewCellGlue alloc] init];
    adViewGlue.model.content = @"并且在此前的公告中，大家也都知道电池老化之后供电不均衡容易造成自动关机，这也是苹果调整这一功能的动机。库克称，想象以下用户在打电话、处理工作和拍摄重要影像的时候突然关机，这种用户体验是不可能被允许的，所以苹果觉得最好做一些什么来防止这些事情的发生。据库克介绍，其实在 iOS 10.2.1第一次引进电源管理功能时，苹果已经在更新日志上进行了解释和介绍了，只是当时关注这个信息的人不多而已。但是在最近的这段争议之后，他们也认为当初应该说得更加清楚明白一些。";
    
    WtDemoAdttionalMoreViewCellGlue *adMoreViewGlue = [[WtDemoAdttionalMoreViewCellGlue alloc] init];
    
    WtDemoAdditionalView *additionalView = [[WtDemoAdditionalView alloc] initWithCellGlues:@[adViewGlue, adMoreViewGlue]];
    self.additionalView = additionalView;
    
    WtDemoCutterAdditionGlue *cellGlue = [[WtDemoCutterAdditionGlue alloc] init];
    cellGlue.additionalView = additionalView;
    
    self.glues = @[cellGlue];
    [self.tableView reloadData];
    
    [additionalView reloadDone:^{
        [self setNavigationButton];
    }];
}

- (void)setNavigationButton {
    UIButton *rItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rItem.frame = CGRectMake(0, 0, 38, 35);
    rItem.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [rItem addTarget:self action:@selector(randomAction) forControlEvents:UIControlEventTouchUpInside];
    [rItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rItem setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [rItem setTitle:@"随机切页" forState:UIControlStateNormal];
    [rItem setTitle:@"随机切页" forState:UIControlStateSelected];
    
    UIButton *lItem = [UIButton buttonWithType:UIButtonTypeCustom];
    lItem.frame = CGRectMake(0, 0, 38, 35);
    lItem.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [lItem addTarget:self action:@selector(noRandomAction) forControlEvents:UIControlEventTouchUpInside];
    [lItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lItem setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [lItem setTitle:@"上次随机切页" forState:UIControlStateNormal];
    [lItem setTitle:@"上次随机切页" forState:UIControlStateSelected];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rItem];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:lItem];
    self.navigationItem.rightBarButtonItems = @[rightItem, leftItem];
    
//    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
//        [rItem sendActionsForControlEvents:UIControlEventTouchUpInside];
//    }];
}

- (void)randomCutter:(BOOL)isRandom {
    NSMutableArray *glues = @[].mutableCopy;
    NSMutableArray *toYs = @[].mutableCopy;
    
    __block CGFloat beginY = 0;
    __block int index = 0;
    NSTimeInterval t = wtDispatch_in_main_clock(^{
        while (YES) {
            CGFloat toY = 0;
            if (!isRandom) {
                if (!(index < self.toYs.count)) break;
                toY = [self.toYs[index] doubleValue];
            }else {
                toY = beginY + arc4random() % 50 + 50;
            }
            [toYs addObject:@(toY)];
            
            WtDemoAdditionalViewCellGlue *adViewGlue = [[WtDemoAdditionalViewCellGlue alloc] init];
            adViewGlue.model.content = @"并且在此前的公告中，大家也都知道电池老化之后供电不均衡容易造成自动关机，这也是苹果调整这一功能的动机。库克称，想象以下用户在打电话、处理工作和拍摄重要影像的时候突然关机，这种用户体验是不可能被允许的，所以苹果觉得最好做一些什么来防止这些事情的发生。据库克介绍，其实在 iOS 10.2.1第一次引进电源管理功能时，苹果已经在更新日志上进行了解释和介绍了，只是当时关注这个信息的人不多而已。但是在最近的这段争议之后，他们也认为当初应该说得更加清楚明白一些。";
            
            WtDemoAdttionalMoreViewCellGlue *adMoreViewGlue = [[WtDemoAdttionalMoreViewCellGlue alloc] init];
            
            if (toY > self.additionalView.wtHeight) {
                toY = floor(self.additionalView.wtHeight);
            }
            
            WtDemoAdditionalView *view = [[WtDemoAdditionalView alloc] initWithCellGlues:@[adViewGlue, adMoreViewGlue]];
            view.wtHeight = self.additionalView.wtHeight;
            WtFindPureColorPoint *pureColorPoint = [WtDemoAdditionalView pureColorPoint];
            
            CGPoint point = CGPointMake(pureColorPoint.beginX, toY);
            if ((int)toY != (int)self.additionalView.wtHeight) {
                point = [self.additionalView wt_findPureColorLineWithBeginAnchor:CGPointMake(pureColorPoint.beginX, toY) length:pureColorPoint.endX sliceNum:5 direction:eWtFindPureSeparateLinePointDirectionUp];
            }
            view.wtY = -beginY;
            CGFloat viewHeight = point.y - beginY;
            
            beginY += viewHeight;
            
            if (beginY > self.additionalView.wtHeight ||
                ((int)self.additionalView.wtHeight == (int)point.y && viewHeight == 0)) {
                break;
            }
            
            UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.wtWidth, viewHeight)];
            [containerView addSubview:view];
            containerView.clipsToBounds = YES;
            
//            // trim
//            {
//                CGPoint point = [containerView wt_trimPureColorLineWithBeginAnchor:CGPointMake(pureColorPoint.beginX, 0) length:pureColorPoint.endX sliceNum:2 direction:eWtFindPureSeparateLinePointDirectionDown];
//                if (!(point.x == -1 && point.y == NSNotFound)) {
//                    containerView.wtHeight -= point.y;
//                    view.wtY -= point.y;
//                }else {
//                    continue;
//                }
//
//                point = [containerView wt_trimPureColorLineWithBeginAnchor:CGPointMake(pureColorPoint.beginX, containerView.wtMaxY) length:pureColorPoint.endX sliceNum:2 direction:eWtFindPureSeparateLinePointDirectionUp];
//                if (!(point.x == -1 && point.y == NSNotFound)) {
//                    containerView.wtHeight -= containerView.wtMaxY - point.y;
//                }
//            }
//            //
            
            if (containerView.wtHeight > 0) {
                WtDemoCutterAdditionGlue *cellGlue = [[WtDemoCutterAdditionGlue alloc] init];
                cellGlue.additionalView = containerView;
                [glues addObject:cellGlue];
            }
            NSLog(@"%s AdditionalViewHeight:%.2f, Index:%d, toY:%.2f, cutterPoint:%@, containerView:%@", __func__, self.additionalView.wtHeight, index, toY, NSStringFromCGPoint(point),containerView);
            
            index++;
        }
    });
    NSLog(@"Cutter view time-consuming:%.0fms", t*1000);
    self.toYs = toYs;
    self.glues = glues;
    [self.tableView reloadData];
}

- (void)randomAction {
    [self randomCutter:YES];
}

- (void)noRandomAction {
    [self randomCutter:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _glues.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellGlue = self.glues[indexPath.section];
    return [cellGlue.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellGlue = self.glues[indexPath.section];
    return [cellGlue.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellGlue = self.glues[indexPath.section];
    [cellGlue.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), [self tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]])];
    lable.text = [NSString stringWithFormat:@"    第%zd页", section];
    lable.font = [UIFont systemFontOfSize:16];
    lable.textColor = [UIColor wtColorWithHTMLName:@"#FFFFFF"];
    lable.backgroundColor = [UIColor wtColorWithHTMLName:@"#9ACED2"];
    return lable;
}
@end
