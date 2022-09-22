//
// NSObject+WtKVO.h
// WtCore
//
// Created by wtfan on 2017/11/23.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"


typedef void (^WtKVOValueChangedBlock)(id _Nullable newValue);

@interface NSObject (WtKVO)

/// Stops all observer blocks from receiving change notifications for the property specified by using wtObserveValueForKeyPath:valueChangedBlock: registered key paths relative to the object receiving this message.
/// Normally, there is no need to call this method manually, it will be called automatically when the object is released.
- (void)wtRemoveAllObserves;

/// Registers the observer block to receive KVO notifications for the key path relative to the object receiving this message.
/// When self-release will trigger automatically remove the KVO observer.
/// @param keyPath The key path, relative to the object receiving this message, of the property to observe. This value must not be nil.
/// @param valueChangedBlock The Callback block.
- (WtKVOValueChangedBlock _Nonnull)wtObserveValueForKeyPath:(NSString *_Nonnull)keyPath
                                          valueChangedBlock:(WtKVOValueChangedBlock _Nonnull)valueChangedBlock;

/// Registers the observer block to receive KVO notifications for the key path relative to the object receiving this message.
/// @param keyPath The key path, relative to the object receiving this message, of the property to observe. This value must not be nil.
/// @param valueChangedBlock The Callback block.
/// @param target When the target call dealloc method will trigger remove the KVO observer.
- (WtKVOValueChangedBlock _Nonnull)wtObserveValueForKeyPath:(NSString *_Nonnull)keyPath
                                          valueChangedBlock:(WtKVOValueChangedBlock _Nonnull)valueChangedBlock
                                     takeUntilTargetDealloc:(id _Nullable)target;

/// Registers the observer block to receive KVO notifications for the key path relative to the object receiving this message.
/// @param keyPath The key path, relative to the object receiving this message, of the property to observe. This value must not be nil.
/// @param valueChangedBlock The Callback block.
/// @param cell When the cell call prepareForReuse method will trigger remove the KVO observer.
- (WtKVOValueChangedBlock _Nonnull)wtObserveValueForKeyPath:(NSString *_Nonnull)keyPath
                                          valueChangedBlock:(WtKVOValueChangedBlock _Nonnull)valueChangedBlock
                          takeUntilTableCellPrepareForReuse:(UITableViewCell *_Nonnull)cell;

/// Registers the observer block to receive KVO notifications for the key path relative to the object receiving this message.
/// @param keyPath The key path, relative to the object receiving this message, of the property to observe. This value must not be nil.
/// @param valueChangedBlock The Callback block.
/// @param collectionReusableView When the collectionReuseView call prepareForReuse method will trigger remove the KVO observer.
- (WtKVOValueChangedBlock _Nonnull)wtObserveValueForKeyPath:(NSString *_Nonnull)keyPath
                                          valueChangedBlock:(WtKVOValueChangedBlock _Nonnull)valueChangedBlock
             takeUntilCollectionReusableViewPrepareForReuse:(UICollectionReusableView *_Nonnull)collectionReusableView;

@end
