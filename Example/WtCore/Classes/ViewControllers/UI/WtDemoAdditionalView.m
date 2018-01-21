//
//  WtDemoAdditionalView.m
//  WtCore_Example
//
//  Created by fanwt on 21/01/2018.
//  Copyright © 2018 JaonFanwt. All rights reserved.
//

#import "WtDemoAdditionalView.h"

@import ReactiveCocoa;

@interface WtDemoAdditionalView ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *glues;
@end

@implementation WtDemoAdditionalView
+ (WtFindPureColorPoint *)pureColorPoint {
    WtFindPureColorPoint *p = [[WtFindPureColorPoint alloc] init];
    p.beginX = 16;
    p.endX = CGRectGetWidth([UIScreen mainScreen].bounds) - 16;
    return p;
}

- (instancetype)initWithCellGlues:(NSArray *)glues {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _glues = glues;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, 0, self.bounds.size.width - 32, self.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled= NO;
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 32, 0.01)];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleHeight |
                                    UIViewAutoresizingFlexibleBottomMargin;
    
    [self addSubview:_tableView];
}

- (void)reloadDone:(void (^)(void))block {
    [self.tableView reloadData];
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        self.wtHeight = self.tableView.contentSize.height;
        wtDispatch_in_main(block);
    });
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellGlue = self.glues[indexPath.section];
    [cellGlue.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
@end
