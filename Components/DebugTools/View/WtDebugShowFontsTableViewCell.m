//
//  WtDebugShowFontsTableViewCell.m
//  WtDebugTools
//
//  Created by fanwt on 2017/12/27.
//

#import "WtDebugShowFontsTableViewCell.h"

#import <Masonry/Masonry.h>

#import "UIColor+WtExtension.h"

@implementation WtDebugShowFontsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    UILabel *englishLabel = [[UILabel alloc] init];
    [self.contentView addSubview:englishLabel];
    englishLabel.numberOfLines = 0;
    englishLabel.textAlignment = NSTextAlignmentLeft;
    englishLabel.font = [UIFont systemFontOfSize:16.0f];
    englishLabel.textColor = [UIColor wtColorWithHTMLName:@"#333333"];
    [englishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(8.0f);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.height.greaterThanOrEqualTo(@20);
    }];
    self.englishLabel = englishLabel;
    
    UILabel *chineseLabel = [[UILabel alloc] init];
    [self.contentView addSubview:chineseLabel];
    chineseLabel.numberOfLines = 0;
    chineseLabel.textAlignment = NSTextAlignmentLeft;
    chineseLabel.font = [UIFont systemFontOfSize:16.0f];
    chineseLabel.textColor = [UIColor wtColorWithHTMLName:@"#666666"];
    [chineseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(englishLabel.mas_bottom).offset(5.0f);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8.0f);
    }];
    self.chineseLabel = chineseLabel;
    
}
@end
