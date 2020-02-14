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


@interface NSObject (WtKVO)

/// Stops all observer blocks from receiving change notifications for the property specified by using wtObserveValueForKeyPath:valueChangedBlock: registered key paths relative to the object receiving this message.
/// Normally, there is no need to call this method manually, it will be called automatically when the object is released.
- (void)wtRemoveAllObserves;

/// Registers the observer block to receive KVO notifications for the key path relative to the object receiving this message.
/// @param keyPath The key path, relative to the object receiving this message, of the property to observe. This value must not be nil.
/// @param valueChangedBlock The Callback block.
- (void)wtObserveValueForKeyPath:(NSString *_Nonnull)keyPath valueChangedBlock:(void (^_Nullable)(id _Nullable newValue))valueChangedBlock;
@end
