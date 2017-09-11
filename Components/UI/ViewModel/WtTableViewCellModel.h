//
//  WtTableViewCellModel.h
//  Pods
//
//  Created by wtfan on 2017/5/17.
//
//

#import <Foundation/Foundation.h>

#import "WtViewModel.h"

@interface WtTableViewCellModel : WtViewModel
@property (nonatomic, strong, readonly) WtDelegateProxy<UITableViewDelegate> *tableViewDelegate;
@property (nonatomic, strong, readonly) WtDelegateProxy<UITableViewDataSource> *tableViewDataSource;

- (UITableViewCell *)loadNibName:(NSString *)nibName index:(NSUInteger)index;
@end
