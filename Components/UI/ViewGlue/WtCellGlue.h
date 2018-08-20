//
//  WtCellGlue.h
//  Pods
//
//  Created by fanwt on 2017/12/19.
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"
#import "WtViewGlue.h"

@protocol WtCellGlueProtocol
@property (nonatomic, strong, readonly) WtDelegateProxy<UITableViewDelegate> *tableViewDelegate;
@property (nonatomic, strong, readonly) WtDelegateProxy<UITableViewDataSource> *tableViewDataSource;
@end

@protocol WtCollectionGlueProtocol
@property (nonatomic, strong, readonly) WtDelegateProxy<UICollectionViewDelegateFlowLayout> *collectionDelegate;
@property (nonatomic, strong, readonly) WtDelegateProxy<UICollectionViewDataSource> *collectionDatasource;
@end


@interface WtCellGlue : WtViewGlue <WtCellGlueProtocol, WtCollectionGlueProtocol>
- (UITableViewCell *)loadNibName:(NSString *)nibName index:(NSUInteger)index;
@end
