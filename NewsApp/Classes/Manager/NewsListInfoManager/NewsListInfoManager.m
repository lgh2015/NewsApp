//
//  NewsListInfoManager.m
//  NewsApp
//
//  Created by lanou on 15/11/11.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import "NewsListInfoManager.h"
#import "AFURLSessionManager.h"
#import "NewsListModel.h"

@interface NewsListInfoManager ()

@property (nonatomic, strong) NSMutableDictionary *newsListURLStringDic;
@property (nonatomic) int currentPage;
@property (nonatomic) int totalPage;

@end

@implementation NewsListInfoManager

#pragma -mark 单例, 便利构造器
+ (instancetype)shareNewsIistInfoManager
{
    static NewsListInfoManager *newsListInfoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        newsListInfoManager = [[NewsListInfoManager alloc]init];
    });
    return newsListInfoManager;
}

#pragma -mark 懒加载
- (NSMutableDictionary *)newsListDataDic
{
    if (!_newsListDataDic) {
        self.newsListDataDic = [[NSMutableDictionary alloc]init];
    }
    return _newsListDataDic;
}

#pragma -mark 懒加载
- (NSMutableDictionary *)newsListScrollDataDic
{
    if (!_newsListScrollDataDic) {
        self.newsListScrollDataDic = [NSMutableDictionary dictionary];
    }
    return _newsListScrollDataDic;
}

#pragma -mark 懒加载, 新闻列表 URL 数组
- (NSMutableDictionary *)newsListURLStringDic
{
    if (!_newsListURLStringDic) {
        self.newsListURLStringDic = [[NSMutableDictionary alloc]initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"API" ofType:@"plist"]];
    }
    return _newsListURLStringDic;
}

#pragma -mark 根据新闻列表 URL 数组下标和索引下表取 model 对象
- (void)acquireDataWithNewsListURLStringDicKey:(NSString *)newsListURLStringKey Completion:(void (^)())completion
{
    /* 创建存放该新闻列表数据的数组 */
    NSMutableArray *newsListDataArr = [NSMutableArray array];
    
    /* 网络请求数据 */
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 3;
    configuration.timeoutIntervalForResource = 3;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:[self.newsListURLStringDic objectForKey:newsListURLStringKey]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSArray *array = [NSArray array];
            NSMutableArray *newsListScrollDataArr = [NSMutableArray array];
            self.currentPage = 1;
            /* 根据新闻列表分类判断数据结构并解析 */
            if ([newsListURLStringKey isEqualToString:@"萌物"]) {
                array = [responseObject objectForKey:@"body"];;
                for (NSDictionary *dic in array) {
                    if ([[dic[@"img"] firstObject] objectForKey:@"url"]) {
                        NewsListModel *newsList = [NewsListModel newsListInfoWithDictionary:dic];
                        [newsListDataArr addObject:newsList];
                    }
                }
            }
            else if ([newsListURLStringKey isEqualToString:@"图片"]){
                self.currentPage = 1;
                array = [[responseObject objectForKey:@"body"] objectForKey:@"item"];;
                for (NSDictionary *dic in array) {
                    NewsListModel *newsList = [NewsListModel newsListInfoWithDictionary:dic];
                    [newsListDataArr addObject:newsList];
                }
            }
            else{
                NSDictionary *Dic = [responseObject firstObject];
                self.currentPage = [[Dic objectForKey:@"currentPage"] intValue];
                self.totalPage = [[Dic objectForKey:@"totalPage"] intValue];
                array = [Dic objectForKey:@"item"];
                for (NSDictionary *dic in array) {
                    NewsListModel *newsList = [NewsListModel newsListInfoWithDictionary:dic];
                    if ([newsList.online intValue] != 0) {
                        [newsListDataArr addObject:newsList];
                    }
                }
                /* 如果该新闻分类有轮播图 */
                NSArray *arr = responseObject;
                if (arr.count > 1) {
                    Dic = arr[1];
                    array = [Dic objectForKey:@"item"];
                    for (NSDictionary *dic in array) {
                        NewsListModel *newsList = [NewsListModel newsListInfoWithDictionary:dic];
                        [newsListScrollDataArr addObject:newsList];
                    }
                    [self.newsListScrollDataDic setObject:newsListScrollDataArr forKey:newsListURLStringKey];
                }
            }
            
            [newsListDataArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NewsListModel *model1 = (NewsListModel *)obj1;
                NewsListModel *model2 = (NewsListModel *)obj2;
                NSString *time1 = model1.updateTime;
                NSString *time2 = model2.updateTime;
                return [time2 compare:time1];
            }];
            [self.newsListDataDic setObject:newsListDataArr forKey:newsListURLStringKey];
            
            completion();
        }
    }];
    [dataTask resume];
}

#pragma -mark 向下继续加载数据的 URLString 拼接方法
- (NSString *)getNextURLStringMethodWithNewsListURLStringDicKey:(NSString *)newsListURLStringKey
{
    self.currentPage += 1;
    NSArray *urlCat = [NSArray array];
    urlCat = [[self.newsListURLStringDic objectForKey:newsListURLStringKey] componentsSeparatedByString:@"gv="];
    NSString *nextURLString = urlCat[0];
    nextURLString = [nextURLString stringByAppendingString:[NSString stringWithFormat:@"page=%d&gv=",self.currentPage]];
    nextURLString = [nextURLString stringByAppendingString:urlCat[1]];
    return nextURLString;
}

#pragma -mark 向下继续加载数据的方法
- (void)acquireDataAgainWithNewsListURLStringDicKey:(NSString *)newsListURLStringKey Completion:(void (^)())completion
{
    NSString *nextURLString = [self getNextURLStringMethodWithNewsListURLStringDicKey:newsListURLStringKey];
    if (self.currentPage > self.totalPage) {
        return;
    }
    
    /* 网络请求数据 */
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 3;
    configuration.timeoutIntervalForResource = 3;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:nextURLString]];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSArray *array = [NSArray array];
            NSMutableArray *nextNewsListDataArr = [NSMutableArray array];
            
            /* 根据新闻列表分类判断数据结构并解析 */
            if ([newsListURLStringKey isEqualToString:@"萌物"]) {
                array = [responseObject objectForKey:@"body"];;
                for (NSDictionary *dic in array) {
                    if ([[dic[@"img"] firstObject] objectForKey:@"url"]) {
                        NewsListModel *newsList = [NewsListModel newsListInfoWithDictionary:dic];
                        [nextNewsListDataArr addObject:newsList];
                    }
                    
                }
            }
            else if ([newsListURLStringKey isEqualToString:@"图片"]){
                array = [[responseObject objectForKey:@"body"] objectForKey:@"item"];;
                
                for (NSDictionary *dic in array) {
                    NewsListModel *newsList = [NewsListModel newsListInfoWithDictionary:dic];
                    [nextNewsListDataArr addObject:newsList];
                }
            }
            else{
                NSDictionary *Dic = [responseObject firstObject];
                self.currentPage = [[Dic objectForKey:@"currentPage"] intValue];
                self.totalPage = [[Dic objectForKey:@"totalPage"] intValue];
                array = [Dic objectForKey:@"item"];
                for (NSDictionary *dic in array) {
                    NewsListModel *newsList = [NewsListModel newsListInfoWithDictionary:dic];
                    if ([newsList.online intValue] != 0) {
                        [nextNewsListDataArr addObject:newsList];
                    }
                }
            }
            
            [nextNewsListDataArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NewsListModel *model1 = (NewsListModel *)obj1;
                NewsListModel *model2 = (NewsListModel *)obj2;
                NSString *time1 = model1.updateTime;
                NSString *time2 = model2.updateTime;
                return [time2 compare:time1];
            }];
            
            [[self.newsListDataDic objectForKey:newsListURLStringKey] addObjectsFromArray:nextNewsListDataArr];
            
            completion();
        }
    }];
    [dataTask resume];
}

#pragma -mark 根据新闻列表 URL 数组下标取 model 对象数据的个数
- (NSInteger)countOfModelsWithNewsListURLStringDicKey:(NSString *)newsListURLStringKey
{
    NSMutableArray *arr = [self.newsListDataDic objectForKey:newsListURLStringKey];
    return arr.count;
}

#pragma -mark 根据新闻列表 URL 数组下标和索引下表取 model 对象
- (id)modelOfNewsListURLStringDicKey:(NSString *)newsListURLStringKey Index:(NSInteger)index
{
    NSMutableArray *arr = [self.newsListDataDic objectForKey:newsListURLStringKey];
    return arr[index];
}

#pragma -mark 根据新闻轮播图 URL 数组下标取 model 对象数据的个数
- (NSInteger)countOfScrollViewModelsWithNewsListURLStringDicKey:(NSString *)newsListURLStringKey
{
    NSMutableArray *arr = [self.newsListScrollDataDic objectForKey:newsListURLStringKey];
    return arr.count;
}

#pragma -mark 根据新闻列表 URL 数组下标和索引下表取 model 对象
- (id)modelOfScrollViewWithNewsListURLStringDicKey:(NSString *)newsListURLStringKey Index:(NSInteger)index
{
    NSMutableArray *arr = [self.newsListScrollDataDic objectForKey:newsListURLStringKey];
    return arr[index];
}

@end
