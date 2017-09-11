//
// Created by wtfan on 2017/5/20.
//

#import "WtDebugSwitchNetworkViewController.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "WtTableViewCellModel.h"

#import "WtDebugSwitchNetworkManager.h"
#import "WtDebugBundle.h"
#import "WtDebugSwitchNetworkItem.h"
#import "WtDebugSwitchNetworkGroup.h"

@interface WtDebugSwitchNetworkViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *datas;
@end

@implementation WtDebugSwitchNetworkViewController
- (void)loadView {
    [super loadView];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 50;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"切换网络";
    [self createDatas];

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"切换网络点击导航栏左侧返回按钮，并在后台杀掉进程重启App后生效."
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlerAddNetworkItemWithIndexPath:(NSInteger)section {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"添加自定义URL" message:@"请输入" delegate:nil cancelButtonTitle:@"添加" otherButtonTitles:nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    [alertView show];

    @weakify(self);
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        @strongify(self);
        UITextField* tf = [alertView textFieldAtIndex:0];
        NSString* tfStr = tf.text;
        WtDebugSwitchNetworkItem *model = [[WtDebugSwitchNetworkItem alloc] init];
        model.urlString = tfStr;
        model.urlDescription = @"自定义";

        WtDebugSwitchNetworkGroup *group = self.datas[section];
        [group addModel:model];
        [self.tableView reloadData];
    }];
}

#pragma mark - Create datas
- (void)createDatas {
    self.datas = [WtDebugSwitchNetworkManager sharedManager].networkGroups;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WtDebugSwitchNetworkGroup *group = _datas[section];
    return group.cellModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtDebugSwitchNetworkGroup *group = _datas[indexPath.section];
    WtTableViewCellModel *cellModel = group.cellModels[indexPath.row];
    return [cellModel.tableViewDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    WtDebugSwitchNetworkGroup *group = _datas[section];
    return group.name;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 44.0f)];
    v.backgroundColor = [UIColor whiteColor];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [v addSubview:b];
    b.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 44.0f);
    [b setImage:[UIImage imageNamed:@"QDKeyboardShowIcon" inBundle:[WtDebugBundle bundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    @weakify(self);
    b.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self handlerAddNetworkItemWithIndexPath:section];
        return [RACSignal empty];
    }];
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WtDebugSwitchNetworkGroup *group = _datas[indexPath.section];
    WtTableViewCellModel *cellModel = group.cellModels[indexPath.row];
    return [cellModel.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WtDebugSwitchNetworkGroup *group = _datas[indexPath.section];
    WtDebugTableViewCellSwitchNetworkModel *cellModel = group.cellModels[indexPath.row];
    [group selectModel:cellModel.model];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WtDebugSwitchNetworkGroup *group = _datas[indexPath.section];
    WtTableViewCellModel *cellModel = group.cellModels[indexPath.row];
    [cellModel.tableViewDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
@end
