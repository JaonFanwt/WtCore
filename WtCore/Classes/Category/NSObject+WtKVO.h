//
//  NSObject+WtKVO.h
//  WtCore
//
//  Created by wtfan on 2017/11/23.
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"

@protocol WtKVODelegate <NSObject>
- (void)valueChanged:(id)value;
@end


@interface NSObject (WtKVO)
- (void)wtObserveValueForKeyPath:(NSString *)keyPath valueChangedBlock:(void (^)(id newValue))valueChangedBlock;
@end
