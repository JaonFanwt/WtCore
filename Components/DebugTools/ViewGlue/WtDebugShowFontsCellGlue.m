//
//  WtDebugShowFontsCellGlue.m
//  WtDebugTools
//
//  Created by fanwt on 2017/12/27.
//

#import "WtDebugShowFontsCellGlue.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtDebugShowFontsTableViewCell.h"
#import "UIColor+WtExtension.h"

// Model
@implementation WtDebugShowFontsCellModel
@synthesize familyName;
@synthesize fontName;
@end

// Glue
@implementation WtDebugShowFontsCellGlue {
    id<WtDebugShowFontsCellModelProtocol> _model;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createControl];
    }
    return self;
}

- (void)createControl {
    @weakify(self);
    [self.tableViewDataSource selector:@selector(tableView:cellForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
        @strongify(self);
        NSString *cellIdentifier = @"WtDebugShowFontsCellldentifier";
        WtDebugShowFontsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[WtDebugShowFontsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.englishLabel.font = [UIFont fontWithName:self.model.fontName size:16.0f];
        cell.chineseLabel.font = [UIFont fontWithName:self.model.fontName size:16.0f];
        cell.englishLabel.text = @"Feng Bujue lost his ability to fear because of an unknown psychological disorder. Through a virtual reality game designed for players to experience fright and despair, he began his search for his lost fear. ";
        cell.chineseLabel.text = @"冯伯爵由于一种前所未有的心理障碍失去了恐惧的能力。通过为玩家设计虚拟现实的游戏来体验恐惧和绝望，他开始寻找他失去的恐惧。";
        return cell;
    }];
    
    [self.tableViewDelegate selector:@selector(tableView:heightForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
        return UITableViewAutomaticDimension;
    }];
    
    [self.tableViewDelegate selector:@selector(tableView:viewForHeaderInSection:) block:^(UITableView *tableView, NSInteger section){
        @strongify(self);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 26)];
        label.backgroundColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"    FamilyName: %@", self.model.familyName];
        return label;
    }];
    
    [self.tableViewDelegate selector:@selector(tableView:heightForHeaderInSection:) block:^(UITableView *tableView, NSInteger section){
        return 26.0f;
    }];
}

- (id<WtDebugShowFontsCellModelProtocol>)model {
    if (!_model) {
        _model = [[WtDebugShowFontsCellModel alloc] init];
    }
    return _model;
}

- (void)setModel:(id<WtDebugShowFontsCellModelProtocol>)model {
    _model = model;
}
@end
