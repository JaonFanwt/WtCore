//
//  WtDebugToolsViewController.m
//  WtDebugTools
//
//  Created by wtfan on 2017/5/10.
//
//

#import "WtDebugToolsViewController.h"

#import <Masonry/Masonry.h>
#import <FLEX/FLEXManager.h>
#import <KMCGeigerCounter/KMCGeigerCounter.h>

#import "WtCellGlue.h"
#import "WtDebugCellGluesManager.h"


@interface WtDebugToolsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;
@end


@implementation WtDebugToolsViewController
- (void)loadView {
  [super loadView];

  UITableView *tableView = [[UITableView alloc] init];
  [self.view addSubview:tableView];
  self.tableView = tableView;
  tableView.delegate = self;
  tableView.dataSource = self;
  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.left.bottom.right.equalTo(self.view);
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  [self createDatas];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Create datas
- (void)createDatas {
  [[WtDebugCellGluesManager shared] installDefault];
  self.datas = [WtDebugCellGluesManager shared].cellGlues;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  WtCellGlue *cellGlue = _datas[indexPath.row];
  return [cellGlue.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  WtCellGlue *cellGlue = _datas[indexPath.row];
  CGFloat height = [cellGlue.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
  return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  WtCellGlue *cellGlue = _datas[indexPath.row];
  [cellGlue.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end
