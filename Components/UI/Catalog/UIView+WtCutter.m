//
//  UIView+WtCutter.m
//  WtCore
//
//  Created by wtfan on 2017/12/26.
//

#import "UIView+WtCutter.h"

#import "UIView+WtUI.h"

@implementation WtFindPureColorPoint
@end

@implementation UIView (WtCutter)
- (CGPoint)wt_upfindPureColorLineWithBeginAnchor:(CGPoint)point
                                           width:(CGFloat)width
                                        sliceNum:(int)sliceNum {
    if (sliceNum == 0 || sliceNum > 10) sliceNum = 5;
    if (point.y > CGRectGetHeight(self.frame)) point.y = CGRectGetHeight(self.frame) - 1;
    
    size_t pixelsWidth = CGRectGetWidth(self.frame);
    if (width < 0 || width > pixelsWidth ) width = pixelsWidth;
    
    CGFloat scale = 1;
    CGFloat sliceHeight = floor(self.frame.size.height*scale / sliceNum);
    if (sliceHeight < self.wtHeight) { // 余下的小数位增一页
        ++sliceNum;
    }
    CGSize size = CGSizeMake(self.frame.size.width*scale, sliceHeight) ;
    CGFloat originY = point.y;
    int sliceIndex = sliceNum - 1;
    BOOL found = NO;
    int i = -1;
    
    int x = point.x;
    int y = point.y;
    
    while ((sliceIndex > 0) && (y >= 0) && (y < sliceIndex * sliceHeight)) {
        sliceIndex--;
    }
    
    NSUInteger beginSliceIndex = sliceIndex;
    
    do {
        int preR = -1, preG = -1, preB = -1, preA = -1;
        
        originY = sliceIndex * sliceHeight; // 起始Y
        CGFloat maxPixelsHeight = (sliceIndex + 1) * sliceHeight; // 该段最大Y
        if (maxPixelsHeight > self.wtHeight) {
            maxPixelsHeight = self.wtHeight;
        }
        if (sliceIndex == beginSliceIndex) {
            y = point.y;
        }else {
            y = maxPixelsHeight - 1;
        }
        x = point.x;
        
        int bitPerRow = size.width * 4;
        int bitCount = bitPerRow * size.height;
        UInt8 *bitdata = malloc(bitCount);
        if (bitdata == NULL) {
            return CGPointMake(-1, INT_MAX);
        }
        
        CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
        if (deviceRGB == NULL) {
            return CGPointMake(-1, INT_MAX);
        }
        
        CGContextRef contex = CGBitmapContextCreate(bitdata, size.width, size.height, 8, bitPerRow, deviceRGB, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        if (contex == NULL) {
            CFRelease(deviceRGB);
            return CGPointMake(-1, INT_MAX);
        }
        
        CFRelease(deviceRGB);
        
        CGContextTranslateCTM(contex, 0, size.height + originY);
        CGContextScaleCTM(contex, scale, -scale);
        
        [self.layer renderInContext:contex];
        
        //        CGImageRef imageRef = CGBitmapContextCreateImage(contex);
        //        UIImage *__image = [UIImage imageWithCGImage:imageRef];
        //
        //        NSLog(@"%s - %@", __func__, __image);
        
        while (true) {
            if (y < 0) {
                x = -1;
                y = INT_MAX;
                break;
            }
            
            if (y < originY) {
                x = point.x;
                y += i;
                break;
            }
            
            if (x >= width) { // found
                x = point.x;
                found = YES;
                break;
            }
            
            int offset = 4*((pixelsWidth*round(y - originY))+round(x));
            if (preR == -1) {
                preR = bitdata[offset];
                preG = bitdata[offset+1];
                preB = bitdata[offset+2];
                preA = bitdata[offset+3];
                
                //                NSLog(@"%s - [起始色值] - [x:%d, y:%d] - [r:%d, g:%d, b:%d, a:%d]", __func__, x, y, bitdata[offset], bitdata[offset+1], bitdata[offset+2], bitdata[offset+3]);
            }else {
                if (preR != bitdata[offset] ||
                    preG != bitdata[offset+1] ||
                    preB != bitdata[offset+2] ||
                    preA != bitdata[offset+3]) {
                    
                    //                    NSLog(@"%s - [色值不一致] - [x:%d, y:%d] - [r:%d, g:%d, b:%d, a:%d]", __func__, x, y, bitdata[offset], bitdata[offset+1], bitdata[offset+2], bitdata[offset+3]);
                    
                    x = point.x;
                    y += i;
                    preR = -1; preG = -1; preB = -1; preA = -1;
                }else {
                    //                    NSLog(@"%s - [色值一致] - [x:%d, y:%d] - [r:%d, g:%d, b:%d, a:%d]", __func__, x, y, bitdata[offset], bitdata[offset+1], bitdata[offset+2], bitdata[offset+3]);
                    x++;
                }
            }
        }
        CGContextRelease(contex);
        free(bitdata);
        sliceIndex--;
    } while (sliceIndex >= 0 && !found);
    
    return CGPointMake(x, y);
}

- (CGPoint)wt_downfindPureColorLineWithBeginAnchor:(CGPoint)point
                                             width:(CGFloat)width
                                          sliceNum:(int)sliceNum {
    if (sliceNum == 0 || sliceNum > 10) sliceNum = 5;
    
    size_t pixelsWidth = CGRectGetWidth(self.frame);
    if (width < 0 || width > pixelsWidth ) width = pixelsWidth;
    
    size_t pixelsHeight = CGRectGetHeight(self.frame);
    
    CGFloat scale = 1;
    CGFloat sliceHeight = floor(self.frame.size.height*scale / sliceNum);
    if (sliceHeight < self.wtHeight) { // 余下的小数位增一页
        ++sliceNum;
    }
    CGFloat originY = point.y;
    int sliceIndex = 0;
    BOOL found = NO;
    int i = 1;
    
    int x = point.x;
    int y = point.y;
    
    while ((y < pixelsHeight) && (y > (sliceIndex + 1) * sliceHeight)) {
        sliceIndex++;
    }
    
    NSUInteger beginSliceIndex = sliceIndex;
    
    do {
        int preR = -1, preG = -1, preB = -1, preA = -1;
        
        originY = sliceIndex * sliceHeight;
        if (sliceIndex == beginSliceIndex) {
            y = point.y;
        }else {
            y = originY;
        }
        x = point.x;
        
        CGFloat maxPixelsHeight = (sliceIndex + 1) * sliceHeight;
        if (maxPixelsHeight > self.wtHeight) {
            maxPixelsHeight = self.wtHeight;
        }
        CGSize size = CGSizeMake(self.frame.size.width*scale, sliceHeight) ;
        int bitPerRow = size.width * 4;
        int bitCount = bitPerRow * size.height;
        UInt8 *bitdata = malloc(bitCount);
        if (bitdata == NULL) {
            return CGPointMake(-1, INT_MAX);
        }
        
        CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
        if (deviceRGB == NULL) {
            return CGPointMake(-1, INT_MAX);
        }
        
        CGContextRef contex = CGBitmapContextCreate(bitdata, size.width, size.height, 8, bitPerRow, deviceRGB, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        if (contex == NULL) {
            CFRelease(deviceRGB);
            return CGPointMake(-1, INT_MAX);
        }
        
        CFRelease(deviceRGB);
        
        CGContextTranslateCTM(contex, 0, size.height + originY);
        CGContextScaleCTM(contex, scale, -scale);
        
        [self.layer renderInContext:contex];
        
        while (true) {
            if (y >= maxPixelsHeight || y < 0) {
                x = -1;
                y = INT_MAX;
                break;
            }
            
            if (x >= width) { // found
                x = point.x;
                found = YES;
                break;
            }
            
            int offset = 4*((pixelsWidth*round(y - originY))+round(x));
            if (preR == -1) {
                preR = bitdata[offset];
                preG = bitdata[offset+1];
                preB = bitdata[offset+2];
                preA = bitdata[offset+3];
            }else {
                if (preR != bitdata[offset] ||
                    preG != bitdata[offset+1] ||
                    preB != bitdata[offset+2] ||
                    preA != bitdata[offset+3]) {
                    
                    x = point.x;
                    y += i;
                    preR = -1; preG = -1; preB = -1; preA = -1;
                }else {
                    x++;
                }
            }
        }
        CGContextRelease(contex);
        free(bitdata);
        
        sliceIndex++;
    } while (sliceIndex < sliceNum && !found);
    
    return CGPointMake(x, y);
}

- (CGPoint)wt_upTrimHeadPureColorLineWithBeginAnchor:(CGPoint)point
                                               width:(CGFloat)width
                                            sliceNum:(int)sliceNum {
    if (sliceNum == 0 || sliceNum > 10) sliceNum = 5;
    
    size_t pixelsWidth = CGRectGetWidth(self.frame);
    if (width < 0 || width > pixelsWidth ) width = pixelsWidth;
    
    CGFloat scale = 1;
    CGFloat sliceHeight = floor(self.frame.size.height*scale / sliceNum);
    if (sliceHeight < self.wtHeight) { // 余下的小数位增一页
        ++sliceNum;
    }
    CGFloat originY = point.y;
    int sliceIndex = sliceNum - 1;
    BOOL found = NO;
    int i = -1;
    
    int x = point.x;
    int y = point.y;
    
    while ((sliceIndex > 0) && (y >= 0) && (y < sliceIndex * sliceHeight)) {
        sliceIndex--;
    }
    
    NSUInteger beginSliceIndex = sliceIndex;
    
    do {
        int preR = -1, preG = -1, preB = -1, preA = -1;
        
        originY = sliceIndex * sliceHeight;
        CGFloat maxPixelsHeight = (sliceIndex + 1) * sliceHeight;
        if (maxPixelsHeight > self.wtHeight) {
            maxPixelsHeight = self.wtHeight;
        }
        if (sliceIndex == beginSliceIndex) {
            y = point.y;
        }else {
            y = maxPixelsHeight-1;
        }
        x = point.x;
        
        CGSize size = CGSizeMake(self.frame.size.width*scale, sliceHeight) ;
        int bitPerRow = size.width * 4;
        int bitCount = bitPerRow * size.height;
        UInt8 *bitdata = malloc(bitCount);
        if (bitdata == NULL) {
            return CGPointMake(-1, INT_MAX);
        }
        
        CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
        if (deviceRGB == NULL) {
            return CGPointMake(-1, INT_MAX);
        }
        
        CGContextRef contex = CGBitmapContextCreate(bitdata, size.width, size.height, 8, bitPerRow, deviceRGB, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        if (contex == NULL) {
            CFRelease(deviceRGB);
            return CGPointMake(-1, INT_MAX);
        }
        
        CFRelease(deviceRGB);
        
        CGContextTranslateCTM(contex, 0, size.height + originY);
        CGContextScaleCTM(contex, scale, -scale);
        
        [self.layer renderInContext:contex];
        
        while (true) {
            if (y < originY) {
                x = -1;
                y = INT_MAX;
                break;
            }
            
            if (x >= width) {
                x = point.x;
                y += i;
                preR = -1; preG = -1; preB = -1; preA = -1;
            }
            
            int offset = 4*((pixelsWidth*round(y - originY))+round(x));
            if (preR == -1) {
                preR = bitdata[offset];
                preG = bitdata[offset+1];
                preB = bitdata[offset+2];
                preA = bitdata[offset+3];
            }else {
                if (preR != bitdata[offset] ||
                    preG != bitdata[offset+1] ||
                    preB != bitdata[offset+2] ||
                    preA != bitdata[offset+3]) {
                    
                    x = point.x;
                    found = YES;
                    break;
                }else {
                    x++;
                }
            }
        }
        CGContextRelease(contex);
        free(bitdata);
        sliceIndex--;
    } while (sliceIndex >= 0 && !found);
    
    return CGPointMake(x, y);
}

- (CGPoint)wt_downTrimHeadPureColorLineWithBeginAnchor:(CGPoint)point
                                                 width:(CGFloat)width
                                              sliceNum:(int)sliceNum {
    if (sliceNum == 0 || sliceNum > 10) sliceNum = 5;
    
    size_t pixelsWidth = CGRectGetWidth(self.frame);
    if (width < 0 || width > pixelsWidth ) width = pixelsWidth;
    
    size_t pixelsHeight = CGRectGetHeight(self.frame);
    
    CGFloat scale = 1;
    CGFloat sliceHeight = floor(self.frame.size.height*scale / sliceNum);
    if (sliceHeight < self.wtHeight) { // 余下的小数位增一页
        ++sliceNum;
    }
    CGFloat originY = point.y;
    int sliceIndex = 0;
    BOOL found = NO;
    int i = 1;
    
    int x = point.x;
    int y = point.y;
    
    while ((y < pixelsHeight) && (y > (sliceIndex + 1) * sliceHeight)) {
        sliceIndex++;
    }
    
    NSUInteger beginSliceIndex = sliceIndex;
    
    do {
        int preR = -1, preG = -1, preB = -1, preA = -1;
        
        originY = sliceIndex * sliceHeight;
        if (sliceIndex == beginSliceIndex) {
            y = point.y;
        }else {
            y = originY;
        }
        x = point.x;
        
        CGFloat maxPixelsHeight = (sliceIndex + 1) * sliceHeight;
        if (maxPixelsHeight > self.wtHeight) {
            maxPixelsHeight = self.wtHeight;
        }
        CGSize size = CGSizeMake(self.frame.size.width*scale, sliceHeight) ;
        int bitPerRow = size.width * 4;
        int bitCount = bitPerRow * size.height;
        UInt8 *bitdata = malloc(bitCount);
        if (bitdata == NULL) {
            return CGPointMake(-1, INT_MAX);
        }
        
        CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
        if (deviceRGB == NULL) {
            return CGPointMake(-1, INT_MAX);
        }
        
        CGContextRef contex = CGBitmapContextCreate(bitdata, size.width, size.height, 8, bitPerRow, deviceRGB, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        if (contex == NULL) {
            CFRelease(deviceRGB);
            return CGPointMake(-1, INT_MAX);
        }
        
        CFRelease(deviceRGB);
        
        CGContextTranslateCTM(contex, 0, size.height + originY);
        CGContextScaleCTM(contex, scale, -scale);
        
        [self.layer renderInContext:contex];
        
        while (true) {
            if (y >= maxPixelsHeight || y < 0) {
                x = -1;
                y = INT_MAX;
                break;
            }
            
            if (x >= width) {
                x = point.x;
                y += i;
                preR = -1; preG = -1; preB = -1; preA = -1;
            }
            
            int offset = 4*((pixelsWidth*round(y - originY))+round(x));
            if (preR == -1) {
                preR = bitdata[offset];
                preG = bitdata[offset+1];
                preB = bitdata[offset+2];
                preA = bitdata[offset+3];
            }else {
                if (preR != bitdata[offset] ||
                    preG != bitdata[offset+1] ||
                    preB != bitdata[offset+2] ||
                    preA != bitdata[offset+3]) { // found
                    
                    x = point.x;
                    found = YES;
                    break;
                }else {
                    x++;
                }
            }
        }
        CGContextRelease(contex);
        free(bitdata);
        
        sliceIndex++;
    } while (sliceIndex < sliceNum && !found);
    
    return CGPointMake(x, y);
}

#pragma mark public
- (CGPoint)wt_findPureColorLineWithBeginAnchor:(CGPoint)point
                                         width:(CGFloat)width
                                      sliceNum:(int)sliceNum
                                     direction:(eWtFindPureSeparateLinePointDirection)direction {
    if (direction == eWtFindPureSeparateLinePointDirectionDown) {
        return [self wt_downfindPureColorLineWithBeginAnchor:point width:width sliceNum:sliceNum];
    }else {
        return [self wt_upfindPureColorLineWithBeginAnchor:point width:width sliceNum:sliceNum];
    }
}

- (CGPoint)wt_trimPureColorLineWithBeginAnchor:(CGPoint)point
                                         width:(CGFloat)width
                                      sliceNum:(int)sliceNum
                                     direction:(eWtFindPureSeparateLinePointDirection)direction {
    if (direction == eWtFindPureSeparateLinePointDirectionDown) {
        return [self wt_downTrimHeadPureColorLineWithBeginAnchor:point width:width sliceNum:sliceNum];
    }else {
        return [self wt_upTrimHeadPureColorLineWithBeginAnchor:point width:width sliceNum:sliceNum];
    }
}
@end
