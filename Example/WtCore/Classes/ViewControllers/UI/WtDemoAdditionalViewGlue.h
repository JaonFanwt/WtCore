//
//  WtDemoAdditionalViewGlue.h
//  WtCore_Example
//
//  Created by fanwt on 21/01/2018.
//  Copyright © 2018 JaonFanwt. All rights reserved.
//

@import UIKit;
@import Foundation;

@import WtCore;

#pragma mark - UI
@interface WtDemoAdditionalViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@end

@interface WtDemoAdttionalMoreViewCell : UITableViewCell

@end

#pragma mark - Model
@protocol WtDemoAdditionalViewCellModelProtocol
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@end

@interface WtDemoAdditionalViewCellModel : NSObject
<WtDemoAdditionalViewCellModelProtocol>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@end

#pragma mark - Glue
@interface WtDemoAdditionalViewCellGlue : WtCellGlue
@property (nonatomic, strong) id<WtDemoAdditionalViewCellModelProtocol> model;
@end

@interface WtDemoAdttionalMoreViewCellGlue : WtCellGlue

@end
