//
//  NSString+WtExtension.h
//  WtCore
//
//  Created by wtfan on 2017/9/12.
//
//

#import <Foundation/Foundation.h>


// Func
Class WTClassFromString(NSString *className);


// Class
@interface NSString (WtExtension)

@end

// HTML
@interface NSString (WtHTML)
- (NSUInteger)wtIntegerValueFromHex;
@end
