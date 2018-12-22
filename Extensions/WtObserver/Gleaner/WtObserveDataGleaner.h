//
//  WtObserveDataGleaner.h
//  WtObserver
//
//  Created by wtfan on 2017/8/24.
//
//

#import <Foundation/Foundation.h>

#import "WtObserveData.h"

#ifndef wtPathCreateIfNotExists
#define wtPathCreateIfNotExists(path)                            \
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) { \
    [[NSFileManager defaultManager] createDirectoryAtPath:path   \
                              withIntermediateDirectories:YES    \
                                               attributes:nil    \
                                                    error:NULL]; \
  }
#endif

typedef enum {
  eWtObserveDataGleanNameNilError = 20101,
  eWtObserveDataGleanValueNilError,
  eWtObserveDataGleanDuplicateError,
} eWtObserveDataGleaneError;


@interface WtObserveDataGleaner : NSObject
@property (nonatomic, readonly) NSMutableDictionary<NSString *, WtObserveData *> *treasures;
+ (instancetype)shared;
- (NSString *)cacheToDisk;
- (BOOL)glean:(NSString *)name columnName:(NSString *)columnName value:(id)value error:(NSError **)error;
@end
