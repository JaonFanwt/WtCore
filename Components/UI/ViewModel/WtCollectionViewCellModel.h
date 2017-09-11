//
//  WtCollectionViewCellModel.h
//  Pods
//
//  Created by wtfan on 2017/9/11.
//
//

#import <Foundation/Foundation.h>

#import "WtViewModel.h"

@interface WtCollectionViewCellModel : WtViewModel
@property (nonatomic, strong, readonly) WtDelegateProxy<UICollectionViewDelegateFlowLayout> *collectionDelegate;
@property (nonatomic, strong, readonly) WtDelegateProxy<UICollectionViewDataSource> *collectionDataSource;
@end
