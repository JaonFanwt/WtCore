//
//  UIView+WtCutter.m
//  WtCore
//
//  Created by wtfan on 2017/12/26.
//

#import "UIView+WtCutter.h"



@implementation UIView (WtCutter)

- (CGPoint)wt_findPureSeparateLinePointWithAnchor:(CGPoint)point direction:(eWtFindPureSeparateLinePointDirection)direction {
    int preR = -1, preG = -1, preB = -1, preA = -1;

    size_t pixelsWidth = CGRectGetWidth(self.frame);
    size_t pixelsHeight = CGRectGetHeight(self.frame);
    int x = point.x;
    int y = point.y;

    CGFloat scale = 1;
    CGSize size = CGSizeMake(self.frame.size.width*scale, self.frame.size.height*scale) ;
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

    CGContextTranslateCTM(contex, 0, size.height);
    CGContextScaleCTM(contex, scale, -scale);

    [self.layer renderInContext:contex];

    int i = (direction==eWtFindPureSeparateLinePointDirectionDown)?1:-1;
    while (true) {
        if (y >= pixelsHeight || y < 0) {
            x = -1;
            y = INT_MAX;
            break;
        }

        if (x >= pixelsWidth) {
            x = point.x;
            break;
        }

        int offset = 4*((pixelsWidth*round(y))+round(x));
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
    return CGPointMake(x, y);
}

@end
