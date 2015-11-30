//
//  RootViewController.m
//  NewsApp
//
//  Created by lanou on 15/11/11.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import "RootViewController.h"
#import "NewsListTableViewController.h"
#import "AppDelegate.h"
#import "NewsListInfoManager.h"
\
#define kNewsListTypeButtonWidth 60

@interface RootViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *newsListTypeBackgroundImageView; // 拟导航栏, 新闻列表分类滚动视图背景图
@property (nonatomic, strong) UIScrollView *typeScrollView;                 // 新闻列表分类的滚动视图

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    myImageView.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:myImageView];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualView.frame = CGRectMake(0, 0, kScreenWidth, 64);
    [myImageView addSubview:visualView];
    
    [self setNewsListTypeBackgroundImageViewMethod];
    [self setLeftMenuButtonMethod];
    [self setTypeScrollViewMethod];
    [self setNewsListTypeButtonMethod];
    [self addChildViewControllersMethod];
    [self setBackgroundScrollViewMethod];
    
    UIButton *button = self.typeScrollView.subviews[0];
    [button setSelected:YES];
    [self.childViewControllers firstObject].view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64);
    [self.backgroundScrollView addSubview:[self.childViewControllers firstObject].view];
}

#pragma -mark 懒加载, 存放新闻列表分类名称的数组
- (NSMutableArray *)newsListTypeNameArr
{
    if (_newsListTypeNameArr == nil) {
        self.newsListTypeNameArr = [[NSMutableArray alloc]initWithObjects:@"头条", @"时政", @"财经", @"体育", @"科技", @"军事", @"数码", @"娱乐", @"房产", @"汽车", @"萌物", @"电影", @"时尚", @"图片", @"国际", @"暖新闻", @"读书", @"旅游", @"健康", @"游戏", nil];
    }
    return _newsListTypeNameArr;
}

#pragma mark---添加子控制器, 新闻列表表视图控制器
- (void)addChildViewControllersMethod
{
    for (int i = 0; i < self.newsListTypeNameArr.count; i++) {
        NewsListTableViewController *newsListTVC = [[NewsListTableViewController alloc]initWithStyle:UITableViewStylePlain];
        newsListTVC.newsListTypeName = self.newsListTypeNameArr[i];
        newsListTVC.view.frame = CGRectMake(i * kScreenWidth, 64, kScreenWidth, kScreenHeight);
        [self addChildViewController:newsListTVC];
    }
}

#pragma -mark 创建背景滚动视图
- (void)setBackgroundScrollViewMethod
{
    self.backgroundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    self.backgroundScrollView.contentSize = CGSizeMake(self.newsListTypeNameArr.count * kScreenWidth, 0);
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.pagingEnabled = YES;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.bounces = NO;
    [self.view addSubview:self.backgroundScrollView];
}

#pragma -mark 创建拟导航栏
- (void)setNewsListTypeBackgroundImageViewMethod
{
    self.newsListTypeBackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.newsListTypeBackgroundImageView.backgroundColor = [UIColor clearColor];
    self.newsListTypeBackgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.newsListTypeBackgroundImageView];
}

#pragma -mark 创建新闻列表分类的 ScrollView
- (void)setTypeScrollViewMethod
{
    self.typeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(40, 20, kScreenWidth - 80, 44)];
    self.typeScrollView.contentSize = CGSizeMake(self.newsListTypeNameArr.count * kNewsListTypeButtonWidth, 0);
    self.typeScrollView.showsHorizontalScrollIndicator = NO;
    self.typeScrollView.bounces = NO;
    [self.newsListTypeBackgroundImageView addSubview:self.typeScrollView];
}

#pragma -mark 创建新闻列表分类的 buttun
- (void)setNewsListTypeButtonMethod
{
    for (int i = 0; i < self.newsListTypeNameArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * kNewsListTypeButtonWidth, 0, kNewsListTypeButtonWidth, 44);
        [button setTitle:self.newsListTypeNameArr[i] forState:UIControlStateNormal];
        [button setTitle:self.newsListTypeNameArr[i] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(newsListTypeButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 100;
        [self.typeScrollView addSubview:button];
    }
}

#pragma -mark 新闻列表分类 buttun 的点击方法
- (void)newsListTypeButtonMethod:(UIButton *)sender
{
    /* 通过新闻列表分类的标记控制背景滚动视图的偏移量 */
    UIButton *button = sender;
    CGPoint offset = CGPointMake((button.tag - 100) * self.backgroundScrollView.frame.size.width, 0);
    [self.backgroundScrollView setContentOffset:offset animated:YES];
}

#pragma -mark ScrollView 的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    /* 手势也有动画 */
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma -mark ScrollView 滑动动画的方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = self.backgroundScrollView.contentOffset.x / kScreenWidth;
    
    NewsListTableViewController *newsListTVC = [[NewsListTableViewController alloc]init];
    newsListTVC.newsListTypeName = self.newsListTypeNameArr[index];
    
    UIButton *button = self.typeScrollView.subviews[index];
    
    /* 之前选中的不被选中, 点击的选中 */
    UIButton *selectedButton = self.typeScrollView.subviews[index];
    selectedButton.selected = YES;
    for (int i = 0; i < self.newsListTypeNameArr.count; i++) {
        UIButton *button = self.typeScrollView.subviews[i];
        if (i != index && button.selected == YES) {
            [button setSelected:NO];
        }
    }
    
    /* 通过新闻列表分类滚动视图控制背景滚动视图(设置偏移量) */
    CGFloat offsetX = button.center.x - self.typeScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = self.typeScrollView.contentSize.width - self.typeScrollView.frame.size.width;
    
    /* 设置前三个和后三个不用移位 */
    if (offsetX < 0) {
        offsetX = 0;
    }else if (offsetX > offsetMax){
        offsetX = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.typeScrollView setContentOffset:offset animated:YES];
    
    /* 在子视图控制器上添加新闻列表表视图 */
    newsListTVC = self.childViewControllers[index];
    newsListTVC.view.frame = self.backgroundScrollView.bounds;
    [self.backgroundScrollView addSubview:newsListTVC.view];
}

#pragma -mark 左上角菜单按钮
- (void)setLeftMenuButtonMethod
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    menuButton.frame = CGRectMake(0, 22, 40, 40);
    [menuButton setImage:[[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [menuButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [menuButton addTarget:self action:@selector(handleLeftMenuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.newsListTypeBackgroundImageView addSubview:menuButton];
}

#pragma -mark 左上角菜单按钮的点击方法
- (void)handleLeftMenuButtonAction:(UIButton *)sender
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

#pragma -mark 视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

#pragma -mark 视图将要推出
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end












