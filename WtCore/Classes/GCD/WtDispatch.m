//
//  WtDispatch.m
//  Pods
//
//  Created by wtfan on 2017/8/30.
//
//

#import "WtDispatch.h"

void wtDispatch_in_main(dispatch_block_t block) {
    if (!block) return;
    
    if ([NSThread isMainThread]) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
