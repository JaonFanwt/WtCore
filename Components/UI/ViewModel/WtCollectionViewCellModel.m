//
//  WtCollectionViewCellModel.m
//  WtUI
//
//  Created by wtfan on 2017/9/11.
//
//

#import "WtCollectionViewCellModel.h"

@implementation WtCollectionViewCellModel
- (instancetype)init {
    if (self = [super init]) {
        _collectionDelegate = (WtDelegateProxy<UICollectionViewDelegateFlowLayout> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UICollectionViewDelegateFlowLayout)];
        _collectionDataSource = (WtDelegateProxy<UICollectionViewDataSource> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(UICollectionViewDataSource)];
    }
    return self;
}
@end
