//
// Created by wtfan on 2017/5/19.
//

#import "WtDebugTableViewCellRightDetailGlue.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtDebugTableViewCellRightDetail.h"
#import "WtDebugSwitchNetworkViewController.h"


@interface WtDebugTableViewCellRightDetailGlue ()
@end


@implementation WtDebugTableViewCellRightDetailGlue

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
    NSString *cellIdentifier = @"WtDebugTableViewCellRightDetaildentifier";
    WtDebugTableViewCellRightDetail *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
      cell = [[WtDebugTableViewCellRightDetail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.titleLabel.text = self.name;
    cell.subTitleLabel.text = self.detailDescription;
    return cell;
  }];

  [self.tableViewDelegate selector:@selector(tableView:heightForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath) {
    if (self.detailDescription.length > 0) {
      return 60.0;
    }
    return 44.0;
  }];
}

@end
