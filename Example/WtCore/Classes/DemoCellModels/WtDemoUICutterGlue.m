//
//  WtDemoUICutterGlue.m
//  WtCore_Example
//
//  Created by wtfan on 2018/1/18.
//  Copyright © 2018年 JaonFanwt. All rights reserved.
//

#import "WtDemoUICutterGlue.h"

@import ReactiveCocoa;

#pragma mark - Model


@implementation WtDemoUICutterModel

@end

#pragma mark - Glue


@implementation WtDemoUICutterGlue {
  id<WtDemoUICutterModelProtocol> _model;
}
- (instancetype)init {
  if (self = [super init]) {
    [self createControl];
  }
  return self;
}

- (void)createControl {
  @weakify(self);
  [self.tableViewDataSource selector:@selector(tableView:cellForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath) {
    @strongify(self);
    static NSString *identifier = @"WtDemoUICutterCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    for (UIView *v in cell.contentView.subviews) {
      [v removeFromSuperview];
    }
    [cell.contentView addSubview:self.model.cutterView];
    return cell;
  }];

  [self.tableViewDelegate selector:@selector(tableView:heightForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath) {
    @strongify(self);
    return CGRectGetHeight(self.model.cutterView.frame);
  }];
}

- (id<WtDemoUICutterModelProtocol>)model {
  if (!_model) {
    _model = [[WtDemoUICutterModel alloc] init];
  }
  return _model;
}

- (void)setModel:(id<WtDemoUICutterModelProtocol>)model {
  _model = model;
}
@end
