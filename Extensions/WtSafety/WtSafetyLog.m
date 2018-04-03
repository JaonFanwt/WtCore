//
//  WtSafetyLog.m
//  WtSafety
//
//  Created by fanwt on 03/04/2018.
//

#import "WtSafetyLog.h"

void wtWarningCallStackSymbols() {
#ifdef DEBUG
    NSLog(@"----------- *[WtSafety warning!]* -----------");
    for (NSString *symbol in [NSThread callStackSymbols]) {
        NSLog(@"%@", symbol);
    }
    NSLog(@"---------------------------------------------");
#endif
}
