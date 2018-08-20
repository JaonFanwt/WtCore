//
//  WtCellGlue.m
//  Pods
//
//  Created by fanwt on 2017/12/19.
//

#import "WtCellGlue.h"


@interface WtCellGlue () {
  WtDelegateProxy<UITableViewDelegate> *_tableViewDelegate;
  WtDelegateProxy<UITableViewDataSource> *_tableViewDataSource;

  WtDelegateProxy<UICollectionViewDelegateFlowLayout> *_collectionDelegate;
  WtDelegateProxy<UICollectionViewDataSource> *_collectionDatasource;
}
@end


@implementation WtCellGlue
- (WtDelegateProxy<UITableViewDelegate> *)tableViewDelegate {
  if (!_tableViewDelegate) {
    _tableViewDelegate = (WtDelegateProxy<UITableViewDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UITableViewDelegate)];
  }
  return _tableViewDelegate;
}

- (WtDelegateProxy<UITableViewDataSource> *)tableViewDataSource {
  if (!_tableViewDataSource) {
    _tableViewDataSource = (WtDelegateProxy<UITableViewDataSource> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UITableViewDataSource)];
  }
  return _tableViewDataSource;
}

#pragma mark - WtCollectionGlueProtocol
- (WtDelegateProxy<UICollectionViewDelegateFlowLayout> *)collectionDelegate {
  if (!_collectionDelegate) {
    _collectionDelegate = (WtDelegateProxy<UICollectionViewDelegateFlowLayout> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UICollectionViewDelegateFlowLayout)];
  }
  return _collectionDelegate;
}

- (WtDelegateProxy<UICollectionViewDataSource> *)collectionDatasource {
  if (!_collectionDatasource) {
    _collectionDatasource = (WtDelegateProxy<UICollectionViewDataSource> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UICollectionViewDataSource)];
  }
  return _collectionDatasource;
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
