//
//  WtDemoCellGlue.m
//  WtCore_Example
//
//  Created by wtfan on 2017/9/1.
//  Copyright © 2017年 JaonFanwt. All rights reserved.
//

#import "WtDemoCellGlue.h"

@import WtCore;


@implementation WtDemoCellGlue
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

    NSString *cellIdentifier = [NSString stringWithFormat:@"%@Identifier", [self class]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    cell.textLabel.text = self.title;
    cell.detailTextLabel.text = self.subTitle;

    return cell;
  }];

  [self.tableViewDelegate selector:@selector(tableView:heightForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath) {
    return 50.0;
  }];
}
@end
