//
//  WtDebugShowFontsViewController.m
//  WtDebugTools
//
//  Created by fanwt on 2017/12/27.
//

#import "WtDebugShowFontsViewController.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtCore.h"
#import "WtDispatch.h"
#import "WtDebugShowFontsCellGlue.h"

@interface WtDebugShowFontsViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;

@property (nonatomic, strong) NSArray *datas;
@end

@implementation WtDebugShowFontsViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingView = loadingView;
    [self.view addSubview:loadingView];
    [loadingView startAnimating];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
    }];
    
    @weakify(self);
    [[RACObserve(tableView, hidden) takeUntil:[tableView rac_willDeallocSignal]] subscribeNext:^(id x) {
        @strongify(self);
        self.loadingView.hidden = ![x boolValue];
    }];
    
    self.tableView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"字体";
    
    [self createDatas];
}

#pragma mark - Create datas
- (void)createDatas {
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        NSMutableArray *models = @[].mutableCopy;
        
        NSLog(@"================= All Fonts ============================");
        for (NSString *familyName in [[UIFont familyNames] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
            NSLog(@" --------- FamilyName: %@ --------- ", familyName);
            NSMutableArray *subModels = @[].mutableCopy;
            [models addObject:subModels];
            
            NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
            for (NSString *fontName in fontNames) {
                NSLog(@"FontName: %@", fontName);
                WtDebugShowFontsCellGlue *glue = [[WtDebugShowFontsCellGlue alloc] init];
                glue.model.familyName = familyName;
                glue.model.fontName = fontName;
                [subModels addObject:glue];
            }
        }
        NSLog(@"================= All Fonts ============================");
        
        self.datas = models;
        
        @weakify(self);
        wtDispatch_in_main(^{
            @strongify(self);
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datas[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellModel = _datas[indexPath.section][indexPath.row];
    return [cellModel.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellModel = _datas[indexPath.section][indexPath.row];
    CGFloat height = [cellModel.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WtCellGlue *cellModel = _datas[indexPath.section][indexPath.row];
    [cellModel.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *cellModels = _datas[section];
    if (cellModels.count == 0) return nil;
    WtCellGlue *cellModel = cellModels[0];
    return [cellModel.tableViewDelegate tableView:tableView viewForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSArray *cellModels = _datas[section];
    if (cellModels.count == 0) return 0.1f;
    WtCellGlue *cellModel = cellModels[0];
    return [cellModel.tableViewDelegate tableView:tableView heightForHeaderInSection:section];
}
@end
