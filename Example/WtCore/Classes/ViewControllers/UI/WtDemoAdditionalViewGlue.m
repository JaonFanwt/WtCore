//
//  WtDemoAdditionalViewGlue.m
//  WtCore_Example
//
//  Created by fanwt on 21/01/2018.
//  Copyright © 2018 JaonFanwt. All rights reserved.
//

#import "WtDemoAdditionalViewGlue.h"

#pragma mark - UI


@implementation WtDemoAdditionalViewCell

@end


@implementation WtDemoAdttionalMoreViewCell

@end

#pragma mark - Model


@implementation WtDemoAdditionalViewCellModel
@end

#pragma mark - Glue


@implementation WtDemoAdditionalViewCellGlue {
  id<WtDemoAdditionalViewCellModelProtocol> _model;
}
- (instancetype)init {
  if (self = [super init]) {
    [self buildDelegateProxies];
  }
  return self;
}

- (void)buildDelegateProxies {
  @weakify(self);
  [self.tableViewDataSource selector:@selector(tableView:cellForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath) {
    @strongify(self);
    static NSString *identifier = @"WtDemoAdditionalViewCellIdentifier";
    WtDemoAdditionalViewCell *cell = (WtDemoAdditionalViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
      cell = (WtDemoAdditionalViewCell *)[self loadNibName:@"WtDemoAdditionalViewCell" index:0];
    }
    cell.contentLabel.text = self.model.content;
    cell.userInteractionEnabled = NO;
    return cell;
  }];
}

- (void)setModel:(id<WtDemoAdditionalViewCellModelProtocol>)model {
  _model = model;
}

- (id<WtDemoAdditionalViewCellModelProtocol>)model {
  if (!_model) {
    _model = [[WtDemoAdditionalViewCellModel alloc] init];
  }
  return _model;
}
@end


@implementation WtDemoAdttionalMoreViewCellGlue
- (instancetype)init {
  if (self = [super init]) {
    [self buildDelegateProxies];
  }
  return self;
}

- (void)buildDelegateProxies {
  @weakify(self);
  [self.tableViewDataSource selector:@selector(tableView:cellForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath) {
    @strongify(self);
    static NSString *identifier = @"WtDemoAdditionalViewCellIdentifier";
    WtDemoAdttionalMoreViewCell *cell = (WtDemoAdttionalMoreViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
      cell = (WtDemoAdttionalMoreViewCell *)[self loadNibName:@"WtDemoAdditionalViewCell" index:1];
    }
    cell.userInteractionEnabled = NO;
    return cell;
  }];
}
@end
