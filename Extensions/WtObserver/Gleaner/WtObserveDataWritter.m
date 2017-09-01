//
//  WtObserveDataWritter.m
//  Pods
//
//  Created by wtfan on 2017/8/24.
//
//

#import "WtObserveDataWritter.h"

#import "WtObserveDataGleaner.h"

@implementation WtObserveDataWritter
+ (NSString *)documentsPath {
    static NSString *path = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [[paths firstObject] copy];
    });
    return path;
}

+ (NSString *)path {
    NSString *p = [[self documentsPath] stringByAppendingPathComponent:@"WtObserveDatas"];
    return p;
}

+ (NSArray<NSString *> *)formatToCSV:(WtObserveData *)observeData {
    if (!observeData) return nil;
    
    NSMutableArray *wrapNames = [NSMutableArray arrayWithCapacity:observeData.keys.count];
    for (int i = 0; i < observeData.keys.count; i++) {
        if (i == 0) {
            [wrapNames addObject:observeData.name];
        }else {
            [wrapNames addObject:@""];
        }
    }
    
    NSMutableArray<NSString *> *lines = [NSMutableArray arrayWithCapacity:10];
    [lines addObject:[wrapNames componentsJoinedByString:@","]]; // 第一行名字
    [lines addObject:[[observeData.keys allObjects] componentsJoinedByString:@","]]; // 第二行字段
    
    // 数据
    NSUInteger row = 0;
    for (int i = 0; i < observeData.keys.count; i++) {
        row = MAX(row, [observeData.values[[observeData.keys allObjects][i]] count]);
    }
    
    for (int i = 0; i < row; i++) {
        NSMutableArray *lineValues = @[].mutableCopy;
        for (int j = 0; j < observeData.keys.count; j++) {
            id key = [observeData.keys allObjects][j];
            NSArray *values = observeData.values[key];
            if (i < values.count) {
                [lineValues addObject:[NSString stringWithFormat:@"%@", values[i]]];
            }else {
                [lineValues addObject:@""];
            }
        }
        [lines addObject:[lineValues componentsJoinedByString:@","]];
    }
    
    return lines;
}

+ (NSString *)toCSV:(NSArray<WtObserveData *> *)observeDatas {
    if (!observeDatas) return nil;
    
    NSUInteger row = 0;
    NSMutableArray *csvArray = [NSMutableArray arrayWithCapacity:observeDatas.count];
    for (WtObserveData *d in observeDatas) {
        NSArray<NSString *> *csv = [self formatToCSV:d];
        [csvArray addObject:csv];
        row = MAX(row, csv.count);
    }
    
    NSMutableArray<NSString *> *lines = @[].mutableCopy;
    
    for (int j = 0; j < csvArray.count; j++) {
        NSArray *values = csvArray[j];
        
        [lines addObjectsFromArray:values];
        [lines addObjectsFromArray:@[@"\n"]];
    }
    
    NSString *s = [lines componentsJoinedByString:@"\n"];
    NSString *path = [self path];
    wtPathCreateIfNotExists(path);
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%.f.csv", [[NSDate date] timeIntervalSince1970]]];
    [s writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return filePath;
}

+ (void)clean {
    NSString *path = [self path];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
@end
