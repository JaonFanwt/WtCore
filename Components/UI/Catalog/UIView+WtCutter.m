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
                                          length:(CGFloat)length
                                        sliceNum:(int)sliceNum {
    if (sliceNum == 0 || sliceNum > 10) sliceNum = 5;
    if (point.y > CGRectGetHeight(self.frame)) point.y = CGRectGetHeight(self.frame) - 1;
    if (self.wtWidth - point.x < length) length = self.wtWidth - point.x;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    size_t pixelsWidth = self.wtWidth * scale;
    size_t pixelsHeight = self.wtHeight * scale;
    point.x = point.x * scale; point.y = point.y * scale; // 根据屏幕尺寸修正一次查找坐标
    
    length = length * scale; // 根据屏幕尺寸修正一次查找长度
    if (length < 0 || length > pixelsWidth ) length = pixelsWidth;
    
    CGFloat sliceHeight = floor(pixelsHeight / sliceNum);
    if (sliceHeight < pixelsHeight) { // 余下的小数位增一页
        ++sliceNum;
    }
    CGSize size = CGSizeMake(pixelsWidth, sliceHeight) ;
    
    CGFloat originY = point.y;
    int sliceIndex = sliceNum - 1;
    BOOL found = NO;
    int i = -1;
    
    NSInteger x = point.x;
    NSInteger y = point.y;
    
    while ((sliceIndex > 0) && (y >= 0) && (y < sliceIndex * sliceHeight)) {
        sliceIndex--;
    }
    
    NSUInteger beginSliceIndex = sliceIndex;
    short pureLineNum = 0;
    
    do {
        int preR = -1, preG = -1, preB = -1, preA = -1;
        
        originY = sliceIndex * sliceHeight; // 起始Y
        CGFloat maxPixelsHeight = (sliceIndex + 1) * sliceHeight; // 该段最大Y
        if (maxPixelsHeight > pixelsHeight) {
            maxPixelsHeight = pixelsHeight;
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
            return CGPointMake(-1, NSNotFound);
        }
        
        CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
        if (deviceRGB == NULL) {
            return CGPointMake(-1, NSNotFound);
        }
        
        CGContextRef contex = CGBitmapContextCreate(bitdata, size.width, size.height, 8, bitPerRow, deviceRGB, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        if (contex == NULL) {
            CFRelease(deviceRGB);
            return CGPointMake(-1, NSNotFound);
        }
        
        CFRelease(deviceRGB);
        
        CGContextSetRGBFillColor(contex, 255.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 1.0f);
        CGContextFillRect(contex, CGRectMake(0, 0, size.width, size.height));
        
        CGContextTranslateCTM(contex, 0, size.height + originY);
        CGContextScaleCTM(contex, scale, -scale);
        
        [self.layer renderInContext:contex];
        
//        CGImageRef imageRef = CGBitmapContextCreateImage(contex);
//        UIImage *__image = [UIImage imageWithCGImage:imageRef];
//
//        NSLog(@"%s - %@", __func__, __image);
        
        int rgbaIdx = 0; // 0:r, 1:g, 2:b, 3:a
        NSArray *rgbaArray = nil;
        while (true) {
            if (x >= length) {
                /*
                 * 为了优化RGBA比较算法，减少比较次数，由相邻色块的RGBA比较改为一行按照R、G、B、A依次来比较，rgbaIdx为记录是当前比较R、G、B、A中哪一个的下标。
                 */
                if (rgbaIdx == 3) {
                    pureLineNum++;
                    x = point.x;
                    if (pureLineNum == scale) { // found
                        found = YES;
                        break;
                    }else {
                        rgbaIdx = 0;
                        x = point.x;
                        y += i;
                        preR = -1; preG = -1; preB = -1; preA = -1;
                    }
                }else {
                    rgbaIdx++;
                    x = point.x;
                }
            }
            
            if (y < 0) {
                x = -1;
                y = NSNotFound;
                break;
            }
            
            if (y < originY) {
                x = point.x;
                y += i;
                break;
            }
            
            int offset = 4*((pixelsWidth*round(y - originY))+round(x));
            if (preR == -1) {
                preR = bitdata[offset];
                preG = bitdata[offset+1];
                preB = bitdata[offset+2];
                preA = bitdata[offset+3];
                rgbaArray = @[@(preR), @(preG), @(preB), @(preA)];
            }else {
                int compareColor = [rgbaArray[rgbaIdx] intValue];
                if (compareColor != bitdata[offset + rgbaIdx]) {
                    rgbaIdx = 0;
                    pureLineNum = 0;
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
        sliceIndex--;
    } while (sliceIndex >= 0 && !found);
    
    if (x == -1 && y == NSNotFound) {
        return CGPointMake(x, y);
    }
    return CGPointMake(x/scale, y/scale);
}

- (CGPoint)wt_downfindPureColorLineWithBeginAnchor:(CGPoint)point
                                            length:(CGFloat)length
                                          sliceNum:(int)sliceNum {
    if (sliceNum == 0 || sliceNum > 10) sliceNum = 5;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    size_t pixelsWidth = self.wtWidth * scale;
    size_t pixelsHeight = self.wtHeight * scale;
    point.x = point.x * scale; point.y = point.y * scale; // 根据屏幕尺寸修正一次查找坐标
    
    length = length * scale; // 根据屏幕尺寸修正一次查找长度
    if (length < 0 || length > pixelsWidth ) length = pixelsWidth;
    
    CGFloat sliceHeight = floor(pixelsHeight / sliceNum);
    if (sliceHeight < pixelsHeight) { // 余下的小数位增一页
        ++sliceNum;
    }
    CGSize size = CGSizeMake(pixelsWidth, sliceHeight) ;
    
    CGFloat originY = point.y;
    int sliceIndex = 0;
    BOOL found = NO;
    int i = 1;
    
    NSInteger x = point.x;
    NSInteger y = point.y;
    
    while ((y < pixelsHeight) && (y > (sliceIndex + 1) * sliceHeight)) {
        sliceIndex++;
    }
    
    NSUInteger beginSliceIndex = sliceIndex;
    short pureLineNum = 0;
    
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
        if (maxPixelsHeight > pixelsHeight) {
            maxPixelsHeight = pixelsHeight;
        }
        int bitPerRow = size.width * 4;
        int bitCount = bitPerRow * size.height;
        UInt8 *bitdata = malloc(bitCount);
        if (bitdata == NULL) {
            return CGPointMake(-1, NSNotFound);
        }
        
        CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
        if (deviceRGB == NULL) {
            return CGPointMake(-1, NSNotFound);
        }
        
        CGContextRef contex = CGBitmapContextCreate(bitdata, size.width, size.height, 8, bitPerRow, deviceRGB, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        if (contex == NULL) {
            CFRelease(deviceRGB);
            return CGPointMake(-1, NSNotFound);
        }
        
        CFRelease(deviceRGB);
        
        CGContextSetRGBFillColor(contex, 255.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 1.0f);
        CGContextFillRect(contex, CGRectMake(0, 0, size.width, size.height));
        
        CGContextTranslateCTM(contex, 0, size.height + originY);
        CGContextScaleCTM(contex, scale, -scale);
        
        [self.layer renderInContext:contex];
        
        int rgbaIdx = 0; // 0:r, 1:g, 2:b, 3:a
        NSArray *rgbaArray = nil;
        while (true) {
            if (x >= length) { // found
                if (rgbaIdx == 3) {
                    pureLineNum++;
                    x = point.x;
                    if (pureLineNum == scale) {
                        found = YES;
                        break;
                    }else {
                        rgbaIdx = 0;
                        x = point.x;
                        y += i;
                        preR = -1; preG = -1; preB = -1; preA = -1;
                    }
                }else {
                    rgbaIdx++;
                    x = point.x;
                }
            }
            
            if (y >= maxPixelsHeight || y < 0) {
                x = -1;
                y = NSNotFound;
                break;
            }
            
            int offset = 4*((pixelsWidth*round(y - originY))+round(x));
            if (preR == -1) {
                preR = bitdata[offset];
                preG = bitdata[offset+1];
                preB = bitdata[offset+2];
                preA = bitdata[offset+3];
                rgbaArray = @[@(preR), @(preG), @(preB), @(preA)];
            }else {
                int compareColor = [rgbaArray[rgbaIdx] intValue];
                if (compareColor != bitdata[offset + rgbaIdx]) {
                    rgbaIdx = 0;
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
    
    if (x == -1 && y == NSNotFound) {
        return CGPointMake(x, y);
    }
    return CGPointMake(x/scale, y/scale);
}

- (CGPoint)wt_upTrimHeadPureColorLineWithBeginAnchor:(CGPoint)point
                                              length:(CGFloat)length
                                            sliceNum:(int)sliceNum {
    if (sliceNum == 0 || sliceNum > 10) sliceNum = 5;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    size_t pixelsWidth = self.wtWidth * scale;
    size_t pixelsHeight = self.wtHeight * scale;
    point.x = point.x * scale; point.y = point.y * scale; // 根据屏幕尺寸修正一次查找坐标
    
    length = length * scale; // 根据屏幕尺寸修正一次查找长度
    if (length < 0 || length > pixelsWidth ) length = pixelsWidth;
    
    CGFloat sliceHeight = floor(pixelsHeight / sliceNum);
    if (sliceHeight < pixelsHeight) { // 余下的小数位增一页
        ++sliceNum;
    }
    CGFloat originY = point.y;
    int sliceIndex = sliceNum - 1;
    BOOL found = NO;
    int i = -1;
    
    NSInteger x = point.x;
    NSInteger y = point.y;
    
    while ((sliceIndex > 0) && (y >= 0) && (y < sliceIndex * sliceHeight)) {
        sliceIndex--;
    }
    
    NSUInteger beginSliceIndex = sliceIndex;
    
    do {
        int preR = -1, preG = -1, preB = -1, preA = -1;
        
        originY = sliceIndex * sliceHeight;
        CGFloat maxPixelsHeight = (sliceIndex + 1) * sliceHeight;
        if (maxPixelsHeight > pixelsHeight) {
            maxPixelsHeight = pixelsHeight;
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
            return CGPointMake(-1, NSNotFound);
        }
        
        CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
        if (deviceRGB == NULL) {
            return CGPointMake(-1, NSNotFound);
        }
        
        CGContextRef contex = CGBitmapContextCreate(bitdata, size.width, size.height, 8, bitPerRow, deviceRGB, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        if (contex == NULL) {
            CFRelease(deviceRGB);
            return CGPointMake(-1, NSNotFound);
        }
        
        CFRelease(deviceRGB);
        
        CGContextSetRGBFillColor(contex, 255.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 1.0f);
        CGContextFillRect(contex, CGRectMake(0, 0, size.width, size.height));
        
        CGContextTranslateCTM(contex, 0, size.height + originY);
        CGContextScaleCTM(contex, scale, -scale);
        
        [self.layer renderInContext:contex];
        
        int rgbaIdx = 0; // 0:r, 1:g, 2:b, 3:a
        NSArray *rgbaArray = nil;
        while (true) {
            if (x >= length) {
                if (rgbaIdx == 3) {
                    rgbaIdx = 0;
                    x = point.x;
                    y += i;
                    preR = -1; preG = -1; preB = -1; preA = -1;
                }else {
                    rgbaIdx++;
                    x = point.x;
                }
            }
            
            if (y < originY) {
                x = -1;
                y = NSNotFound;
                break;
            }
            
            int offset = 4*((pixelsWidth*round(y - originY))+round(x));
            if (preR == -1) {
                preR = bitdata[offset];
                preG = bitdata[offset+1];
                preB = bitdata[offset+2];
                preA = bitdata[offset+3];
                rgbaArray = @[@(preR), @(preG), @(preB), @(preA)];
            }else {
                int compareColor = [rgbaArray[rgbaIdx] intValue];
                if (compareColor != bitdata[offset + rgbaIdx]) {
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
    
    if (x == -1 && y == NSNotFound) {
        return CGPointMake(x, y);
    }
    return CGPointMake(x/scale, y/scale);
}

- (CGPoint)wt_downTrimHeadPureColorLineWithBeginAnchor:(CGPoint)point
                                                length:(CGFloat)length
                                              sliceNum:(int)sliceNum {
    if (sliceNum == 0 || sliceNum > 10) sliceNum = 5;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    size_t pixelsWidth = self.wtWidth * scale;
    size_t pixelsHeight = self.wtHeight * scale;
    point.x = point.x * scale; point.y = point.y * scale; // 根据屏幕尺寸修正一次查找坐标
    
    length = length * scale; // 根据屏幕尺寸修正一次查找长度
    if (length < 0 || length > pixelsWidth ) length = pixelsWidth;
    
    CGFloat sliceHeight = floor(pixelsHeight / sliceNum);
    if (sliceHeight < pixelsHeight) { // 余下的小数位增一页
        ++sliceNum;
    }
    CGFloat originY = point.y;
    int sliceIndex = 0;
    BOOL found = NO;
    int i = 1;
    
    NSInteger x = point.x;
    NSInteger y = point.y;
    
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
        if (maxPixelsHeight > pixelsHeight) {
            maxPixelsHeight = pixelsHeight;
        }
        CGSize size = CGSizeMake(self.frame.size.width*scale, sliceHeight) ;
        int bitPerRow = size.width * 4;
        int bitCount = bitPerRow * size.height;
        UInt8 *bitdata = malloc(bitCount);
        if (bitdata == NULL) {
            return CGPointMake(-1, NSNotFound);
        }
        
        CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB();
        if (deviceRGB == NULL) {
            return CGPointMake(-1, NSNotFound);
        }
        
        CGContextRef contex = CGBitmapContextCreate(bitdata, size.width, size.height, 8, bitPerRow, deviceRGB, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        if (contex == NULL) {
            CFRelease(deviceRGB);
            return CGPointMake(-1, NSNotFound);
        }
        
        CFRelease(deviceRGB);
        
        CGContextSetRGBFillColor(contex, 255.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 1.0f);
        CGContextFillRect(contex, CGRectMake(0, 0, size.width, size.height));
        
        CGContextTranslateCTM(contex, 0, size.height + originY);
        CGContextScaleCTM(contex, scale, -scale);
        
        [self.layer renderInContext:contex];
        
        CGImageRef imageRef = CGBitmapContextCreateImage(contex);
        UIImage *__image = [UIImage imageWithCGImage:imageRef];
        
        NSLog(@"%s - %@", __func__, __image);
        
        int rgbaIdx = 0; // 0:r, 1:g, 2:b, 3:a
        NSArray *rgbaArray = nil;
        while (true) {
            if (x >= length) {
                if (rgbaIdx == 3) {
                    rgbaIdx = 0;
                    x = point.x;
                    y += i;
                    preR = -1; preG = -1; preB = -1; preA = -1;
                }else {
                    rgbaIdx++;
                    x = point.x;
                }
            }
            
            if (y >= maxPixelsHeight || y < 0) {
                x = -1;
                y = NSNotFound;
                break;
            }
            
            int offset = 4*((pixelsWidth*round(y - originY))+round(x));
            if (preR == -1) {
                preR = bitdata[offset];
                preG = bitdata[offset+1];
                preB = bitdata[offset+2];
                preA = bitdata[offset+3];
                rgbaArray = @[@(preR), @(preG), @(preB), @(preA)];
            }else {
                int compareColor = [rgbaArray[rgbaIdx] intValue];
                if (compareColor != bitdata[offset + rgbaIdx]) {
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
    
    if (x == -1 && y == NSNotFound) {
        return CGPointMake(x, y);
    }
    return CGPointMake(x/scale, y/scale);
}

#pragma mark public
- (CGPoint)wt_findPureColorLineWithBeginAnchor:(CGPoint)point
                                        length:(CGFloat)length
                                      sliceNum:(int)sliceNum
                                     direction:(eWtFindPureSeparateLinePointDirection)direction {
    if (direction == eWtFindPureSeparateLinePointDirectionDown) {
        return [self wt_downfindPureColorLineWithBeginAnchor:point length:length sliceNum:sliceNum];
    }else {
        return [self wt_upfindPureColorLineWithBeginAnchor:point length:length sliceNum:sliceNum];
    }
}

- (CGPoint)wt_trimPureColorLineWithBeginAnchor:(CGPoint)point
                                        length:(CGFloat)length
                                      sliceNum:(int)sliceNum
                                     direction:(eWtFindPureSeparateLinePointDirection)direction {
    if (direction == eWtFindPureSeparateLinePointDirectionDown) {
        return [self wt_downTrimHeadPureColorLineWithBeginAnchor:point length:length sliceNum:sliceNum];
    }else {
        return [self wt_upTrimHeadPureColorLineWithBeginAnchor:point length:length sliceNum:sliceNum];
    }
}
@end

