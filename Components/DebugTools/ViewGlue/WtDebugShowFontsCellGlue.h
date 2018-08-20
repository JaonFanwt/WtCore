//
//  WtDebugShowFontsCellGlue.h
//  WtDebugTools
//
//  Created by fanwt on 2017/12/27.
//

#import <Foundation/Foundation.h>

#import "WtCellGlue.h"

// Model
@protocol WtDebugShowFontsCellModelProtocol
@property (nonatomic, copy) NSString *familyName;
@property (nonatomic, copy) NSString *fontName;
@end


@interface WtDebugShowFontsCellModel : NSObject <WtDebugShowFontsCellModelProtocol>
@end

// Glue
@interface WtDebugShowFontsCellGlue : WtCellGlue
@property (nonatomic, strong) id<WtDebugShowFontsCellModelProtocol> model;
@end
