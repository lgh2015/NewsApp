//
//  NewsListTableViewController.m
//  NewsApp
//
//  Created by lanou on 15/11/11.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import "NewsListTableViewController.h"
#import "NewsDetailViewController.h"
#import "NewsListModel.h"
#import "NewsListInfoManager.h"
#import "UIImageView+WebCache.h"
#import "NewsListWithoutImageCell.h"
#import "NewsListWithOneImageCell.h"
#import "NewsListWithImagesCell.h"
#import "NewsListPetCell.h"
#import "ImageViewOnScrollView.h"
#import "MJRefresh.h"
#import "RootViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width                              // 屏幕的宽度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height                            // 屏幕的高度
#define kImageWidth ((kScreenWidth - 10 - 10 + 5) / 3 - 5)                                // 图片宽度
#define kHLColor(r, g, b) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0]       // 自定义颜色

@interface NewsListTableViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *photoOnScrollViewArr;
@property (nonatomic, strong) UIScrollView *photoScrollView;
@property (nonatomic) BOOL isFirstTime;                                 // 是否第一次推出该新闻列表分类表视图

@end

@implementation NewsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    /* 是, 第一次推出该新闻列表分类表视图*/
    self.isFirstTime = YES;
    
    /* 萌物 cell 不能被点击进入详情页面 */
    if ([self.newsListTypeName isEqualToString:@"萌物"]) {
        self.tableView.allowsSelection = NO;
    }
    
    [self registerCustomCellMethod];
}

#pragma -mark 分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma -mark 单元(row)数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[NewsListInfoManager shareNewsIistInfoManager] countOfModelsWithNewsListURLStringDicKey:self.newsListTypeName];
}

#pragma -mark 设置单元高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListModel *newsList = [[NewsListInfoManager shareNewsIistInfoManager] modelOfNewsListURLStringDicKey:self.newsListTypeName Index:indexPath.row];
    if (newsList.imageArr.count == 0) {
        return 80;
    }
    if (newsList.imageArr.count == 1) {
        /* 萌物 cell 的自定义高度 */
        if ([self.newsListTypeName isEqualToString:@"萌物"]) {
            NSString *imageW = [[newsList.img[0] objectForKey:@"size"] objectForKey:@"width"];
            NSString *imageH = [[newsList.img[0] objectForKey:@"size"] objectForKey:@"height"];
            CGFloat rateOfImageWH = [imageW floatValue] / [imageH floatValue];
            return  (kScreenWidth - 20) / rateOfImageWH + 20;
        }
        else return 5 + kImageWidth * 9 / 16 + 5;
    }
    /* 多张图片的 cell 高度 */
    else return 30 + kImageWidth * 9 / 16 + 20;
}

#pragma -mark 设置单元
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsListModel *newsList = [[NewsListInfoManager shareNewsIistInfoManager] modelOfNewsListURLStringDicKey:self.newsListTypeName Index:indexPath.row];
    if (newsList.imageArr.count == 0) {
        NewsListWithoutImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListWithoutImage" forIndexPath:indexPath];
        cell.titleLabel.text = newsList.title;
        cell.updateTimeLabel.text = newsList.updateTime;
        if (newsList.updateTime != nil) {
            cell.updateTimeLabel.text = newsList.updateTime;
        }
        if ([newsList.comments isEqualToString:@"0"] || newsList.comments == nil) {
            
        }
        else{
            cell.commentsLabel.text = newsList.comments;
            cell.commentsImageView.image = [UIImage imageNamed:@"cell_comment.png"];
        }
        return cell;
    }
    else if (newsList.imageArr.count == 1){
        if ([self.newsListTypeName isEqualToString:@"萌物"]) {
            NewsListPetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListPet" forIndexPath:indexPath];
            NSString *imageW = [[newsList.img[0] objectForKey:@"size"] objectForKey:@"width"];
            NSString *imageH = [[newsList.img[0] objectForKey:@"size"] objectForKey:@"height"];
            CGFloat rateOfImageWH = [imageW floatValue] / [imageH floatValue];
            cell.myImageView.frame = CGRectMake(10, 10, kScreenWidth - 20, (kScreenWidth - 20) / rateOfImageWH);
            [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:newsList.imageArr[0]] placeholderImage:[UIImage imageNamed:@"photo_holder"]];
            return cell;
        }
        else{
            NewsListWithOneImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListWithOneImage" forIndexPath:indexPath];
            cell.titleLabel.text = newsList.title;
            cell.updateTimeLabel.text = newsList.updateTime;
            if (newsList.updateTime != nil) {
                cell.updateTimeLabel.text = newsList.updateTime;
            }
            if ([newsList.comments isEqualToString:@"0"] || newsList.comments == nil) {
                
            }
            else{
                cell.commentsLabel.text = newsList.comments;
                cell.commentsImageView.image = [UIImage imageNamed:@"cell_comment.png"];
            }
            [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:newsList.imageArr[0]] placeholderImage:[UIImage imageNamed:@"photo_holder"]];
            return cell;
        }
    }
    else{
        NewsListWithImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListWithImages" forIndexPath:indexPath];
        cell.titleLabel.text = newsList.title;
        cell.updateTimeLabel.text = newsList.updateTime;
        if (newsList.updateTime != nil) {
            cell.updateTimeLabel.text = newsList.updateTime;
        }
        if ([newsList.comments isEqualToString:@"0"] || newsList.comments == nil) {
            
        }
        else{
            cell.commentsLabel.text = newsList.comments;
            cell.commentsImageView.image = [UIImage imageNamed:@"cell_comment.png"];
        }
        [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:newsList.imageArr[0]] placeholderImage:[UIImage imageNamed:@"photo_holder"]];
        [cell.iImageView sd_setImageWithURL:[NSURL URLWithString:newsList.imageArr[1]] placeholderImage:[UIImage imageNamed:@"photo_holder"]];
        if (newsList.imageArr.count > 2) {
            [cell.mineImageView sd_setImageWithURL:[NSURL URLWithString:newsList.imageArr[2]] placeholderImage:[UIImage imageNamed:@"photo_holder"]];
        }
        return cell;
    }
}

#pragma -mark cell 单元的点击方法, 点击取消选中状态, 标题改为红色, 推出详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc]init];
    if ([self.newsListTypeName isEqualToString:@"图片"]) {
        NSDictionary *dic = [[[[NewsListInfoManager shareNewsIistInfoManager] modelOfNewsListURLStringDicKey:self.newsListTypeName Index:indexPath.row] links] firstObject];
        newsDetailVC.detailUrl = dic[@"url"];
        newsDetailVC.newsListTypeName = self.newsListTypeName;
    }
    else{
        newsDetailVC.detailUrl=[[[NewsListInfoManager shareNewsIistInfoManager] modelOfNewsListURLStringDicKey:self.newsListTypeName Index:indexPath.row] detailUrl];
        newsDetailVC.newsListTypeName = self.newsListTypeName;
    }
    [self presentViewController:newsDetailVC animated:YES completion:nil];
    
}

#pragma -mark 视图将要推出的方法, 数据重新加载
- (void)viewWillAppear:(BOOL)animated{
    if (self.isFirstTime) {
        RootViewController *rootVC = [[RootViewController alloc]init];

        NSArray *arr = [[NewsListInfoManager shareNewsIistInfoManager].newsListDataDic objectForKey:self.newsListTypeName];
        
        /* 如果是 头条新闻列表分类 和  当前新闻列表分表没有数据, 进行网络请求 */
        if ([self.newsListTypeName isEqualToString:rootVC.newsListTypeNameArr[0]] || arr.count == 0) {
            [[NewsListInfoManager shareNewsIistInfoManager] acquireDataWithNewsListURLStringDicKey:self.newsListTypeName Completion:^{
                [self.tableView reloadData];
                
                /* 获取轮播图数据 */
                NSArray *array = [[NewsListInfoManager shareNewsIistInfoManager].newsListScrollDataDic objectForKey:self.newsListTypeName];
                
                /* 轮播图数据不为空 */
                if (array.count != 0) {
                    [self setPhotoScrollViewMethod];
                    self.tableView.tableHeaderView = self.photoScrollView;
                }
            }];
        }
        else{
            [self.tableView reloadData];
            /* 获取轮播图数据 */
            NSArray *array = [[NewsListInfoManager shareNewsIistInfoManager].newsListScrollDataDic objectForKey:self.newsListTypeName];
            
            /* 轮播图数据不为空 */
            if (array.count != 0) {
                [self setPhotoScrollViewMethod];
                self.tableView.tableHeaderView = self.photoScrollView;
            }
        }
        
        
        /* 获取下个新闻列表分类的下标 */
        int index = 0;
        for (int i = 0; i < rootVC.newsListTypeNameArr.count; i++) {
            if ([self.newsListTypeName isEqualToString:rootVC.newsListTypeNameArr[i]]) {
                index = i + 1;
            }
        }

        /* 对下一个新闻列表分类进行网络请求, 如果下标不等于数组个数 */
        if (index != rootVC.newsListTypeNameArr.count) {
            [[NewsListInfoManager shareNewsIistInfoManager] acquireDataWithNewsListURLStringDicKey:rootVC.newsListTypeNameArr[index] Completion:^{

            }];
        }
        
        /* 不是, 第一次推出该新闻列表分类表视图 */
        self.isFirstTime = NO;
    }
    
    /* 马上进入上拉刷新状态 */
    [self.tableView.mj_footer beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [[NewsListInfoManager shareNewsIistInfoManager] acquireDataAgainWithNewsListURLStringDicKey:self.newsListTypeName Completion:^{
            [self.tableView reloadData];
        }];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    /* 马上进入下拉刷新状态 */
    [self.tableView.header beginRefreshing];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NewsListInfoManager shareNewsIistInfoManager] acquireDataWithNewsListURLStringDicKey:self.newsListTypeName Completion:^{
            [self.tableView reloadData];
        }];
        [self.tableView.header endRefreshing];
    }];
}

#pragma -mark 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 注册自定义 cell
- (void)registerCustomCellMethod
{
    [self.tableView registerClass:[NewsListWithoutImageCell class] forCellReuseIdentifier:@"NewsListWithoutImage"];
    [self.tableView registerClass:[NewsListWithOneImageCell class] forCellReuseIdentifier:@"NewsListWithOneImage"];
    [self.tableView registerClass:[NewsListWithImagesCell class] forCellReuseIdentifier:@"NewsListWithImages"];
    [self.tableView registerClass:[NewsListPetCell class] forCellReuseIdentifier:@"NewsListPet"];
}

#pragma -mark 设置轮播图
- (void)setPhotoScrollViewMethod
{
    self.photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 2)];
    self.photoScrollView.delegate = self;
    self.photoScrollView.pagingEnabled = YES;
    [self setPhotoOnPhotoScrollViewMethod];
    self.photoScrollView.contentSize = CGSizeMake(kScreenWidth * self.photoOnScrollViewArr.count, kScreenWidth / 2);
    self.photoScrollView.showsHorizontalScrollIndicator = NO;
    self.photoScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
}

#pragma -mark 设置轮播图上的 imageView
- (void)setPhotoOnPhotoScrollViewMethod
{
    self.photoOnScrollViewArr = [NSMutableArray array];
    NSArray *arr = [[NewsListInfoManager shareNewsIistInfoManager].newsListScrollDataDic objectForKey:self.newsListTypeName];
    if (arr != nil) {
        for (NewsListModel *newsList in arr) {
            [self.photoOnScrollViewArr addObject:newsList];
        }
        if (self.photoOnScrollViewArr.count > 1) {
            [self.photoOnScrollViewArr insertObject:self.photoOnScrollViewArr[self.photoOnScrollViewArr.count - 1] atIndex:0];
            [self.photoOnScrollViewArr addObject:self.photoOnScrollViewArr[1]];
        }
    }
    for (int i = 0; i < self.photoOnScrollViewArr.count; i++) {
        NewsListModel *newsList = self.photoOnScrollViewArr[i];
        
        ImageViewOnScrollView *imageView = [[ImageViewOnScrollView alloc]initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenWidth / 2)];
        imageView.urlString = newsList.detailUrl;
        [imageView sd_setImageWithURL:[NSURL URLWithString:newsList.thumbnail] placeholderImage:[UIImage imageNamed:@"photo_holder.png"]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleImageViewOnPhotoScrollViewAction:)]];
        [self.photoScrollView addSubview:imageView];
        
        UIImageView *shadowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * kScreenWidth, kScreenWidth / 2 - 40, kScreenWidth, 40)];
        shadowImageView.image = [UIImage imageNamed:@"aboutDownMask"];
        [self.photoScrollView addSubview:shadowImageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * kScreenWidth + 10, kScreenWidth / 2 - 20, kScreenWidth - 10, 20)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = newsList.title;
        label.textColor = [UIColor whiteColor];
        [self.photoScrollView addSubview:label];
    }
}

#pragma -mark 轮播图上的 imageView 的点击方法
- (void)handleImageViewOnPhotoScrollViewAction:(UITapGestureRecognizer *)sender
{
    ImageViewOnScrollView *imageView = (ImageViewOnScrollView *)sender.view;
    NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc]init];
    newsDetailVC.detailUrl = imageView.urlString;
    newsDetailVC.newsListTypeName = self.newsListTypeName;
    [self presentViewController:newsDetailVC animated:YES completion:nil];
}

#pragma -mark 设置轮播图偏移量实现滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.photoScrollView.contentOffset.x > (self.photoOnScrollViewArr.count - 2) * kScreenWidth) {
        self.photoScrollView.contentOffset = CGPointMake(0, 0);
    }
    if (self.photoScrollView.contentOffset.x < 0) {
        self.photoScrollView.contentOffset = CGPointMake((self.photoOnScrollViewArr.count - 2) * kScreenWidth, 0);
    }
}

@end
