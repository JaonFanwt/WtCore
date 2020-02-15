//
// WtDelegateProxy.h
// WtCore
//
// Created by wtfan on 2017/7/29.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>


/// Extracts and returns a struct name from the specifying type encode string.
/// @param typeEncodeString The type encode string.
/// e.g: {CGRect={CGPoint=dd}{CGSize=dd}} -> CGRect
extern NSString * _Nonnull wtExtractStructName(NSString * _Nullable typeEncodeString);


@interface WtDelegateProxy : NSObject
@property (nonatomic, weak) id _Nullable delegate; /// The original delegate.

/// Initializes and returns a newly allocated delegate proxy object with the specified Protocol.
/// @param protocol A protocol.
- (instancetype _Nullable)initWithProtocol:(Protocol * _Nonnull)protocol;

/// Associates the method of the protocol with a block, when the method is called, the block is executed.
/// @param selector A Selector that identifies the method to bind.
/// @param block The block implementation of the Selector.
/// Supported parameter types:
///   1.basic types;
///   2.NSObject classes;
///   3.Common structs
///     * NSRange、CGPoint、CGVector、CGSize、CGRect、CGAffineTransform
///     * UIEdgeInsets、UIOffset
///     * NSDirectionalEdgeInsets (iOS11+)
- (void)selector:(SEL _Nonnull)selector block:(id _Nullable)block;

@end
