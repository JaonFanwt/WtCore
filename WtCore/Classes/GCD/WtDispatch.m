//
//  WtDispatch.m
//  WtCore
//
//  Created by wtfan on 2017/8/30.
//
//

#import "WtDispatch.h"

#import "CTBlockDescription.h"

#import "WtDelegateProxy.h"

#pragma mark private
void __wtDispatch_in_main(id block, va_list arg_ptr) {
    if (!block) return;

    CTBlockDescription *blockDescription = [[CTBlockDescription alloc] initWithBlock:block];
    if (!blockDescription) return;

    NSMethodSignature *blockMethodSignature = blockDescription.blockSignature;
    NSInvocation *blockInvocation = [NSInvocation invocationWithMethodSignature:blockMethodSignature];

    for (NSInteger i = 1; i < blockInvocation.methodSignature.numberOfArguments; i++) {
        const char *argumentType = [blockInvocation.methodSignature getArgumentTypeAtIndex:i];
        switch (argumentType[0] == 'r' ? argumentType[1] : argumentType[0]) {
#define WT_DIS_ARG_CASE(_typeChar, _type) \
case _typeChar: { \
_type arg; \
arg = va_arg(arg_ptr, _type); \
[blockInvocation setArgument:&arg atIndex:i]; \
break; \
}
                WT_DIS_ARG_CASE('c', int)
                WT_DIS_ARG_CASE('C', int)
                WT_DIS_ARG_CASE('s', int)
                WT_DIS_ARG_CASE('S', int)
                WT_DIS_ARG_CASE('i', int)
                WT_DIS_ARG_CASE('I', unsigned int)
                WT_DIS_ARG_CASE('l', long)
                WT_DIS_ARG_CASE('L', unsigned long)
                WT_DIS_ARG_CASE('q', long long)
                WT_DIS_ARG_CASE('Q', unsigned long long)
                WT_DIS_ARG_CASE('f', double)
                WT_DIS_ARG_CASE('d', double)
                WT_DIS_ARG_CASE('B', int)
            case '@': {
                __unsafe_unretained id arg;
                arg = va_arg(arg_ptr, __unsafe_unretained id);
                [blockInvocation setArgument:&arg atIndex:i];
                break;
            }
            case '{': {
                NSString *typeString = wtExtractStructName([NSString stringWithUTF8String:argumentType]);
#define WT_DIS_ARG_STRUCT(_type) \
if ([typeString rangeOfString:@#_type].location != NSNotFound) { \
_type arg; \
arg = va_arg(arg_ptr, _type); \
[blockInvocation setArgument:&arg atIndex:i]; \
break; \
}
                WT_DIS_ARG_STRUCT(CGRect)
                WT_DIS_ARG_STRUCT(CGPoint)
                WT_DIS_ARG_STRUCT(CGSize)
                WT_DIS_ARG_STRUCT(NSRange)
                WT_DIS_ARG_STRUCT(UIEdgeInsets)
                break;
            }
            case ':': {
                SEL selector;
                selector = va_arg(arg_ptr, SEL);
                [blockInvocation setArgument:&selector atIndex:i];
                break;
            }
            case '^':
            case '*': {
                void *arg;
                arg = va_arg(arg_ptr, void*);
                [blockInvocation setArgument:&arg atIndex:i];
                break;
            }
            case '#': {
                Class arg;
                arg = va_arg(arg_ptr, Class);
                [blockInvocation setArgument:&arg atIndex:i];
                break;
            }
            default: {
                NSLog(@"error type %s", argumentType);
                break;
            }
        }
    }

    if ([NSThread isMainThread]) {
        [blockInvocation invokeWithTarget:blockDescription.block];
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockInvocation invokeWithTarget:blockDescription.block];
        });
    }
}

#pragma mark public
void wtDispatch_in_main(id block, ...) {
    if (!block) return;

    va_list arg_ptr; // 可变参数指针
    va_start(arg_ptr, block);

    __wtDispatch_in_main(block, arg_ptr);

    va_end(arg_ptr);
}

NSTimeInterval wtDispatch_in_main_clock(id block, ...) {
    if (!block) return 0.0;

    va_list arg_ptr; // 可变参数指针
    va_start(arg_ptr, block);

    NSDate *beginDate = [NSDate date];

    __wtDispatch_in_main(block, arg_ptr);

    NSDate *endDate = [NSDate date];

    va_end(arg_ptr);
    return [endDate timeIntervalSince1970] - [beginDate timeIntervalSince1970];
}
