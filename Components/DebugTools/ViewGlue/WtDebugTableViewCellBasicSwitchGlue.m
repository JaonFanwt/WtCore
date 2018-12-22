//
// Created by wtfan on 2017/5/19.
//

#import "WtDebugTableViewCellBasicSwitchGlue.h"

#import "WtCore.h"
#import "WtEXTScope.h"
#import "UIControl+WtUI.h"
#import "WtEXTKeyPathCoding.h"
#import "WtDebugTableViewCellBasicSwitch.h"


@interface WtDebugTableViewCellBasicSwitchGlue ()
@end


@implementation WtDebugTableViewCellBasicSwitchGlue

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
    NSString *cellIdentifier = @"WtDebugTableViewCellBasicSwitchIdentifier";
    WtDebugTableViewCellBasicSwitch *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
      cell = [[WtDebugTableViewCellBasicSwitch alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.titleLabel.text = self.name;
    cell.subTitleLabel.text = self.detailDescription;
    cell.switchControl.on = self.switchOn;

    @weakify(self, cell);
    [cell.switchControl wtAction:^(UIControl *control, UIControlEvents controlEvents) {
      @strongify(self);
      self.switchOn = cell.switchControl.on;
    } forControlEvents:UIControlEventValueChanged];

    [self wtObserveValueForKeyPath:@keypath(self, switchOn) valueChangedBlock:^(id newValue) {
      @strongify(cell);
      cell.switchControl.on = [newValue boolValue];
    }];

    return cell;
  }];

  [self.tableViewDelegate selector:@selector(tableView:heightForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath) {
    @strongify(self);
    if (self.detailDescription.length > 0) {
      return 60.0;
    }
    return 44.0;
  }];
}

@end
