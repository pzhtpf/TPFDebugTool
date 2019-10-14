//
//  JxbHttpVC.m
//  JxbHttpProtocol
//
//  Created by Peter Jin @ https://github.com/JxbSir on 15/11/12.
//  Copyright (c) 2015年 Mail:i@Jxb.name. All rights reserved.
//

#import "JxbHttpVC.h"
#import "JxbHttpDetailVC.h"
#import "JxbDebugTool.h"
#import "JxbHttpCell.h"

@interface JxbHttpVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *listData;
@end

@implementation JxbHttpVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Http"];

    UIButton *btnclear = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclear.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclear setTitle:@"清空" forState:UIControlStateNormal];
    [btnclear addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [btnclear setTitleColor:[JxbDebugTool shareInstance].mainColor forState:UIControlStateNormal];

    UIBarButtonItem *btnright = [[UIBarButtonItem alloc] initWithCustomView:btnclear];
    self.navigationItem.rightBarButtonItem = btnright;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];

    [self reloadHttp];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHttp) name:kNotifyKeyReloadHttp object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setLeftBarButtonItem];
    });
}

- (void)setLeftBarButtonItem {
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[JxbDebugTool shareInstance].mainColor forState:UIControlStateNormal];

    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
}

- (void)dismissViewController {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [[JxbDebugTool shareInstance] showDebug];
}

- (void)clearAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[JxbHttpDatasource shareInstance] clear];
        self.listData = nil;
        [self.tableView reloadData];
    });
}

- (void)reloadHttp {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.listData = [[[JxbHttpDatasource shareInstance] httpArray] copy];
        [self.tableView reloadData];
    });
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"httpcell";
    JxbHttpCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[JxbHttpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    JxbHttpModel *model = [self.listData objectAtIndex:indexPath.row];
//    [cell setTitle:model.url.host value:model.url.path];
    [cell setModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JxbHttpModel *model = [self.listData objectAtIndex:indexPath.row];
    JxbHttpDetailVC *vc = [[JxbHttpDetailVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.detail = model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
