//
//  WtDemoUICutterGlue.h
//  WtCore_Example
//
//  Created by wtfan on 2018/1/18.
//  Copyright © 2018年 JaonFanwt. All rights reserved.
//

#import <Foundation/Foundation.h>

@import WtCore;

#pragma mark - Model
@protocol WtDemoUICutterModelProtocol
@property (nonatomic, strong) UIView *cutterView;
@end

@interface WtDemoUICutterModel : NSObject
<WtDemoUICutterModelProtocol>
@property (nonatomic, strong) UIView *cutterView;
@end

#pragma mark - Glue
@interface WtDemoUICutterGlue : WtCellGlue
@property (nonatomic, strong) id<WtDemoUICutterModelProtocol> model;
@end
