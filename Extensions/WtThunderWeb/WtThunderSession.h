//
//  WtThunderSession.h
//  Pods
//
//  Created by wtfan on 2017/8/29.
//
//

#import <Foundation/Foundation.h>

#pragma mark - Protocol
@class WtThunderSession;
@protocol WtThunderSessionDelegate <NSObject>
- (void)session:(WtThunderSession *)session didRecieveResponse:(NSURLResponse *)response;
- (void)session:(WtThunderSession *)session didLoadData:(NSData *)date;
- (void)session:(WtThunderSession *)session didFaild:(NSError *)error;
- (void)sessionDidFinish:(WtThunderSession *)session;
@end

#pragma mark - Function
NSString *thunderSessionID(NSString *urlString, NSString *userIdentifier);

#pragma mark - Class
@interface WtThunderSession : NSObject
@property (nonatomic, assign, readonly) NSTimeInterval beginTime;
@property (nonatomic, assign, readonly) NSTimeInterval endTime;

@property (nonatomic, readonly) NSString *urlString;
@property (nonatomic, readonly) NSString *sessionID;
@property (nonatomic, weak) id<WtThunderSessionDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isCompletion;
@property (nonatomic, strong, readonly) NSURLResponse *response;
@property (nonatomic, strong, readonly) NSMutableData *responseData;
@property (nonatomic, strong, readonly) NSError *error;

- (instancetype)initWithURLString:(NSString *)urlString userIdentifier:(NSString *)userIdentifier;
- (void)start;
- (void)cancel;
- (BOOL)isExpiredWithMaxAge:(NSTimeInterval)maxAge;
@end
