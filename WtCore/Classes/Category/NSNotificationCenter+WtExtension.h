//
//  NSNotificationCenter+WtExtension.h
//  WtCore
//
//  Created by wtfan on 2022/8/9.
//

#import <Foundation/Foundation.h>

typedef void (^WtNotificationBlock)(NSNotification *_Nullable notification, id _Nullable observer);

@interface NSNotificationCenter (WtExtension)

/// Registers the observer block to receive notifications that passed to the provided block.
/// The block runs synchronously on the posting thread.
///
/// @param name
///          The name of the notification to register for delivery to the observer block. Specify a notification name to deliver only entries with this notification name.
///          When nil, the sender doesn’t use notification names as criteria for delivery.
/// @param object
///          The object that sends notifications to the observer block. Specify a sender to deliver only notifications from this sender.
///          When nil, the notification center doesn’t use the sender as criteria for the delivery.
/// @param block
///          The Callback block.
/// @param target
///          When the target call dealloc method will trigger remove the notification observer.
- (WtNotificationBlock _Nonnull)wtAddObserverForName:(NSString *_Nonnull)name
                                              object:(id _Nullable)object
                                               block:(WtNotificationBlock _Nonnull)block
                              takeUntilTargetDealloc:(id _Nonnull)target;

/// Registers the observer block to receive notifications that passed to the provided block.
/// @param name
///          The name of the notification to register for delivery to the observer block. Specify a notification name to deliver only entries with this notification name.
///          When nil, the sender doesn’t use notification names as criteria for delivery.
/// @param object
///          The object that sends notifications to the observer block. Specify a sender to deliver only notifications from this sender.
///          When nil, the notification center doesn’t use the sender as criteria for the delivery.
/// @param queue
///          The operation queue where the block runs.
///          When nil, the block runs synchronously on the posting thread.
/// @param block
///          The Callback block.
/// @param target
///          When the target call dealloc method will trigger remove the notification observer.
- (WtNotificationBlock _Nonnull)wtAddObserverForName:(NSString *_Nonnull)name
                                              object:(id _Nullable)object
                                               queue:(nullable NSOperationQueue *)queue
                                               block:(WtNotificationBlock _Nonnull)block
                              takeUntilTargetDealloc:(id _Nonnull)target;

@end
