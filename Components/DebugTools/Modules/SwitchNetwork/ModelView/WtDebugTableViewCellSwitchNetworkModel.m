//
//  WtDebugTableViewCellSwitchNetworkModel
//  WtDebugTools
//
//  Created by wtfan on 2017/5/22.
//

#import "WtDebugTableViewCellSwitchNetworkModel.h"

#import "WtEXTScope.h"
#import "WtDebugTableViewCellSwitchNetwork.h"


@interface WtDebugTableViewCellSwitchNetworkModel ()
@end


@implementation WtDebugTableViewCellSwitchNetworkModel
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

    NSString *cellIdentifier = @"WtDebugTableViewCellSwitchNetworkentifier";
    WtDebugTableViewCellSwitchNetwork *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
      cell = [[WtDebugTableViewCellSwitchNetwork alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.titleLabel.text = self.model.urlString;
    cell.subTitleLabel.text = self.model.urlDescription;
    return cell;
  }];

  [self.tableViewDelegate selector:@selector(tableView:heightForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath) {
    @strongify(self);
    if (self.model.urlDescription.length > 0) {
      return 60.0;
    }
    return 44.0;
  }];

  [self.tableViewDelegate selector:@selector(tableView:willDisplayCell:forRowAtIndexPath:) block:^(UITableView *_Nonnull tableView, UITableViewCell *_Nonnull cell, NSIndexPath *_Nonnull indexPath) {
    @strongify(self);
    [cell setSelected:self.model.isSelected animated:NO];
  }];
}

@end
