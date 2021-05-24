//
//  WtSafetyTool.m
//  WtCore
//
//  Created by fanweitian on 2021/5/24.
//

#import "WtSafetyTool.h"

typedef unsigned char Byte;

void _wtReverseBytes(void *s, int size) {
  unsigned char *lo = s;
  unsigned char *hi = s + size - 1;
  unsigned char swap;
  while (lo < hi) {
    swap = *lo;
    *lo++ = *hi;
    *hi-- = swap;
  }
}

NSString *wtStringFromReversedChar(void *chars, int length) {
  _wtReverseBytes(chars, length);
  NSData *data = [NSData dataWithBytes:chars length:length];
  return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
