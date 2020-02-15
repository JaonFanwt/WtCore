//
// NSTimer+WtExtension.h
// WtCore
//
// Created by wtfan on 2020/2/4.
// Copyright © 2020 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>


@interface NSTimer (WtAutoInvalidate)

/// Automatically invalid on owner release.
/// @param owner The owner of this timer.
- (void)wtAutoInvalidateWhenOwnerDealloc:(_Nonnull id)owner;

/// Automatically invalid on target release.
/// Creates and returns a new NSTimer object with the target object and it's SEL. This timer needs to be scheduled on a run loop (via -[NSRunLoop addTimer:]) before it will fire.
/// @param interval  The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead
/// @param aTarget The execution target of the timer, the timer auto invalidate on target release.
/// @param aSelector The execution SEL of the timer, the timer itself is passed as the parameter to this SEL when executed.
/// @param userInfo The user information dictionary associated with the timer.
/// @param repeats If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
+ (NSTimer *_Nonnull)wtTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(_Nonnull id)aTarget
                                    selector:(SEL _Nonnull )aSelector
                                    userInfo:(nullable id)userInfo
                                     repeats:(BOOL)repeats;

/// Automatically invalid on target release.
/// Creates and returns a new NSTimer object and schedules it on the current runloop in the default mode.
/// @param interval The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead
/// @param aTarget The execution target of the timer, the timer auto invalidate on target release.
/// @param aSelector The execution SEL of the timer, the timer itself is passed as the parameter to this SEL when executed.
/// @param userInfo The user information dictionary associated with the timer.
/// @param repeats If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
+ (NSTimer *_Nonnull)wtScheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                               target:(_Nonnull id)aTarget
                                             selector:(SEL _Nonnull )aSelector
                                             userInfo:(nullable id)userInfo
                                              repeats:(BOOL)repeats;

/// Automatically invalid on owner release.
/// Creates and returns a new NSTimer object initialized with the specified block object. This timer needs to be scheduled on a run loop (via -[NSRunLoop addTimer:]) before it will fire.
/// @param interval The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead
/// @param repeats If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
/// @param owner The owner of this timer, the timer auto invalidate on owner release.
/// @param block The execution body of the timer; the timer itself is passed as the parameter to this block when executed to aid in avoiding cyclical references
+ (NSTimer *_Nonnull)wtTimerWithTimeInterval:(NSTimeInterval)interval
                                     repeats:(BOOL)repeats
              autoInvalidateWhenOwnerDealloc:(_Nonnull id)owner
                                       block:(void (^_Nullable)(NSTimer * _Nullable timer))block;

/// Automatically invalid on owner release.
/// Creates and returns a new NSTimer object initialized with the specified block object and schedules it on the current run loop in the default mode.
/// @param interval The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead
/// @param repeats If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
/// @param owner The owner of this timer, the timer auto invalidate on owner release.
/// @param block The execution body of the timer; the timer itself is passed as the parameter to this block when executed to aid in avoiding cyclical references
+ (NSTimer *_Nonnull)wtScheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                              repeats:(BOOL)repeats
                       autoInvalidateWhenOwnerDealloc:(_Nonnull id)owner
                                                block:(void (^_Nullable)(NSTimer * _Nonnull timer))block;

@end
