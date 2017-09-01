//
//  WtDebugTableViewCellRightDetail.m
//  Pods
//
//  Created by wtfan on 2017/5/17.
//
//

#import "WtDebugTableViewCellRightDetail.h"

#import <Masonry/Masonry.h>

#import "WtDebugBundle.h"

@implementation WtDebugTableViewCellRightDetail

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    UIImage *detailImage = [UIImage imageNamed:@"CellDetail" inBundle:[WtDebugBundle bundle] compatibleWithTraitCollection:nil];

    UIImageView *detailImageView = [[UIImageView alloc] initWithImage:detailImage];
    [self.contentView addSubview:detailImageView];
    [detailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@21);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    [self.contentView addSubview:detailLabel];
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.font = [UIFont systemFontOfSize:14.0f];
    detailLabel.textColor = [UIColor colorWithRed:153.0/256.0 green:153.0/256.0  blue:153.0/256.0  alpha:1.0];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(detailImageView.mas_left).offset(2);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@17);
    }];
    self.subTitleLabel = detailLabel;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor colorWithRed:51.0/256.0 green:51.0/256.0 blue:51.0/256.0 alpha:1.0];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(detailLabel.mas_left).offset(2);
        make.height.mas_equalTo(@17);
    }];
    self.titleLabel = titleLabel;
    
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
