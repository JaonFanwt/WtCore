//
//  WtDebugTableViewCellSwitchNetwork
//  WtDebugTools
//
//  Created by wtfan on 2017/5/19.
//

#import "WtDebugTableViewCellSwitchNetwork.h"

#import <Masonry/Masonry.h>


@implementation WtDebugTableViewCellSwitchNetwork
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    [self createSubViews];
  }
  return self;
}

- (void)createSubViews {
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  titleLabel.backgroundColor = [UIColor clearColor];
  subTitleLabel.backgroundColor = [UIColor clearColor];

  self.titleLabel = titleLabel;
  self.subTitleLabel = subTitleLabel;

  [self.contentView addSubview:titleLabel];
  [self.contentView addSubview:subTitleLabel];

  titleLabel.font = [UIFont systemFontOfSize:16];
  subTitleLabel.font = [UIFont systemFontOfSize:12];
  subTitleLabel.numberOfLines = 0;
  titleLabel.highlightedTextColor = [UIColor colorWithRed:212.0 / 256.0 green:60.0 / 256.0 blue:51.0 / 256.0 alpha:1.0];
  subTitleLabel.textColor = [UIColor lightGrayColor];

  [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentView.mas_top).with.offset(5);
    make.left.equalTo(self.contentView.mas_left).with.offset(20);
    make.right.equalTo(self.contentView.mas_right).with.offset(-12);
    make.height.mas_offset(20);
  }];
  [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView.mas_left).with.offset(20);
    make.right.equalTo(self.contentView.mas_right).with.offset(-12);
    make.top.equalTo(titleLabel.mas_bottom).with.offset(2);
    make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-5);
  }];

  {
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithRed:219. / 256. green:219. / 256. blue:219. / 256. alpha:1.0];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView).offset(18.0);
      make.right.bottom.width.equalTo(self.contentView);
      make.height.mas_equalTo(@0.6f);
    }];
  }

  UIView *bkView_s = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds))];
  bkView_s.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;
  bkView_s.backgroundColor = [UIColor colorWithRed:250.0 / 256.0 green:250.0 / 256.0 blue:250.0 / 256.0 alpha:1.0];
  self.selectedBackgroundView = bkView_s;

  UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
  line.backgroundColor = [UIColor colorWithRed:219. / 256. green:219. / 256. blue:219. / 256. alpha:1.0];
  [bkView_s addSubview:line];
  [line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(bkView_s).offset(18.0);
    make.right.bottom.width.equalTo(bkView_s);
    make.height.mas_equalTo(@0.6f);
  }];
}

@end
