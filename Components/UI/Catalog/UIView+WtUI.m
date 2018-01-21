//
//  UIView+WtUI.m
//  WtCore
//
//  Created by wtfan on 2018/1/7.
//

#import "UIView+WtUI.h"

#import <objc/runtime.h>

#import "WtDispatch.h"
#import "UIGestureRecognizer+WtUI.h"

@implementation UIView (WtUI)
#pragma mark public
- (CGFloat)wtX {
    return self.frame.origin.x;
}

- (CGFloat)wtMinX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)wtMidX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)wtMaxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setWtX:(CGFloat)wtX {
    CGRect rect = self.frame;
    rect.origin.x = wtX;
    self.frame = rect;
}

- (CGFloat)wtY {
    return self.frame.origin.y;
}

- (CGFloat)wtMinY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)wtMidY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)wtMaxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setWtY:(CGFloat)wtY {
    CGRect rect = self.frame;
    rect.origin.y = wtY;
    self.frame = rect;
}

- (CGFloat)wtWidth {
    return self.frame.size.width;
}

- (void)setWtWidth:(CGFloat)wtWidth {
    CGRect rect = self.frame;
    rect.size.width = wtWidth;
    self.frame = rect;
}

- (CGFloat)wtHeight {
    return self.frame.size.height;
}

- (void)setWtHeight:(CGFloat)wtHeight {
    CGRect rect = self.frame;
    rect.size.height = wtHeight;
    self.frame = rect;
}

#pragma mark - public
- (void)wtWhenTapped:(void (^)(void))block {
    self.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGesture = objc_getAssociatedObject(self, _cmd);
    if (tapGesture) {
        [self removeGestureRecognizer:tapGesture];
    }

    tapGesture = [UITapGestureRecognizer wtWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        wtDispatch_in_main(block);
    }];
    objc_setAssociatedObject(self, _cmd, tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addGestureRecognizer:tapGesture];
}

- (UInt8 *)bitdataWithFrame:(CGRect)frame scale:(CGFloat)scale {
    CGSize size = CGSizeMake(frame.size.width*scale, frame.size.height*scale) ;

    int bitPerRow = size.width * 4;
    int bitCount = bitPerRow * size.height;
    UInt8 *bitdata = malloc(bitCount);
    if (bitdata == NULL) {
        return nil;
    }

    CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
    if (deviceRGB == NULL) {
        return nil;
    }

    CGContextRef context = CGBitmapContextCreate(bitdata, size.width, size.height, 8, bitPerRow, deviceRGB, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    if (context == NULL) {
        CFRelease(deviceRGB);
        return nil;
    }

    CFRelease(deviceRGB);

    CGContextTranslateCTM(context, -frame.origin.x, size.height + frame.origin.y);
    CGContextScaleCTM(context, scale, -scale);

    [self.layer renderInContext:context];

    CGContextRelease(context);
    free(bitdata);

    return bitdata;
}
@end
