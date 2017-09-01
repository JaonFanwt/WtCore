//
//  WtDebugTableViewCellBasicSwitch.m
//  Pods
//
//  Created by wtfan on 2017/5/17.
//
//

#import "WtDebugTableViewCellBasicSwitch.h"

#import <Masonry/Masonry.h>

@implementation WtDebugTableViewCellBasicSwitch

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    UISwitch *sw = [[UISwitch alloc] init];
    [self.contentView addSubview:sw];
    [sw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
        
    }];
    self.switchControl = sw;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor colorWithRed:51.0/256.0 green:51.0/256.0 blue:51.0/256.0 alpha:1.0];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(sw.mas_left).offset(28);
        make.height.mas_equalTo(@21);
    }];
    self.titleLabel = titleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:subTitleLabel];
    subTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    subTitleLabel.textColor = [UIColor colorWithRed:153.0/256.0 green:153.0/256.0  blue:153.0/256.0  alpha:1.0];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(sw.mas_left).offset(28);
    }];
    self.subTitleLabel = subTitleLabel;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [UIColor colorWithRed:219./256. green:219./256. blue:219./256. alpha:1.0];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(18.0);
        make.right.bottom.width.equalTo(self.contentView);
        make.height.mas_equalTo(@0.6f);
    }];
}

@end
