//
//  WtTableViewCellModel.m
//  Pods
//
//  Created by wtfan on 2017/5/17.
//
//

#import "WtTableViewCellModel.h"

@implementation WtTableViewCellModel
- (instancetype)init {
    if (self = [super init]) {
        _tableViewDelegate = (WtDelegateProxy<UITableViewDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UITableViewDelegate)];
        _tableViewDataSource = (WtDelegateProxy<UITableViewDataSource> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UITableViewDataSource)];
    }
    return self;
}

#pragma mark - public

- (UITableViewCell *)loadNibName:(NSString *)nibName index:(NSUInteger)index {
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
#if DEBUG
    NSAssert(xibs != nil, @"XIB不存在!!!");
    NSAssert(index <= (xibs.count - 1), @"访问XIB越界!!!");
#endif
    if (!xibs) return nil;
    if (index > (xibs.count - 1)) return nil;
    UITableViewCell *cell = xibs[index];
    return cell;
}
@end
