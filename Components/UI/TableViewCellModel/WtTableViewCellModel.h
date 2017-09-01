//
//  WtTableViewCellModel.h
//  Pods
//
//  Created by wtfan on 2017/5/17.
//
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"

@interface WtTableViewCellModel : NSObject
@property (nonatomic, strong) WtDelegateProxy<UITableViewDelegate> *tableViewDelegate;
@property (nonatomic, strong) WtDelegateProxy<UITableViewDataSource> *tableViewDataSource;

- (UITableViewCell *)loadNibName:(NSString *)nibName index:(NSUInteger)index;
@end
