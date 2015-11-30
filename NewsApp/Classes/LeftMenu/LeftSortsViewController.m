//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "ExonerateViewController.h"
#import "SDImageCache.h"
#import "RootViewController.h"
#import "MenuViewController.h"

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBackgroundImageViewMethod];
    [self setTableviewMethod];
}

#pragma -mark 设置背景图
- (void)setBackgroundImageViewMethod
{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"left.jpg"];
    [self.view addSubview:imageview];
}

#pragma -mark 设置表视图
- (void)setTableviewMethod
{
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableview.dataSource = self;
    self.tableview.delegate  = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
}

#pragma -mark 设置单元数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma -mark 设置单元
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
    }
    cell.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 0, 80, 44);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 44)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentLeft;
        if (indexPath.row == 0) {
            label.text = @"-新闻";
            label.textColor = [UIColor colorWithRed:245/255.0 green:40/255.0 blue:53/255.0 alpha:1];
            [btn addTarget:self action:@selector(ButtionACtion:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row == 1) {
            label.text = @"-清除缓存";
            label.textColor = [UIColor colorWithRed:0 green:159/255.0 blue:1 alpha:1];
            [btn addTarget:self action:@selector(ActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row == 2) {
            label.text = @"-免责声明";
            label.textColor = [UIColor brownColor];
            [btn addTarget:self action:@selector(handBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell addSubview:label];
        [cell addSubview:btn];
    }
    return cell;
}

#pragma -mark 新闻 cell 的点击方法
-(void)ButtionACtion:(UIButton *)sender{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC closeLeftView];    //关闭左侧抽屉
}

#pragma -mark 免责声明按钮
-(void)handBtnAction:(UIButton *)sender{
    ExonerateViewController * ExoneVC = [[ExonerateViewController alloc]init];
    [self presentViewController:ExoneVC animated:YES completion:nil];
}

#pragma -mark 清除缓存
-(void)ActionBtn:(UIButton *)sender{
    [[SDImageCache sharedImageCache]clearDisk];
    [self setAlterActionMethod];
}

#pragma -mark 设置清除缓存成功提示框
- (void)setAlterActionMethod
{
    UIAlertController *Alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"清除缓存成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [Alert addAction:Action];
    [self presentViewController:Alert animated:YES completion:nil];
}

#pragma -mark cell 的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma -mark 设置分区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}

#pragma -mark 设置分区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma -mark 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
