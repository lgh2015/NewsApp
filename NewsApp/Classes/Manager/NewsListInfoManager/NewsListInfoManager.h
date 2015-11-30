//
//  NewsListInfoManager.h
//  NewsApp
//
//  Created by lanou on 15/11/11.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsListInfoManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *newsListScrollDataDic;
@property (nonatomic, strong) NSMutableDictionary *newsListDataDic;

+ (instancetype)shareNewsIistInfoManager;   // 单例, 便利构造器

/* 根据新闻列表 URL 数组下标进行网络请求, 获取数据 */
- (void)acquireDataWithNewsListURLStringDicKey:(NSString *)newsListURLStringKey Completion:(void (^)())completion;

/* 向下继续加载数据的方法 */
- (void)acquireDataAgainWithNewsListURLStringDicKey:(NSString *)newsListURLStringKey Completion:(void (^)())completion;

/* 根据新闻列表 URL 数组下标和索引下标取 model 对象*/
- (id)modelOfNewsListURLStringDicKey:(NSString *)newsListURLStringKey Index:(NSInteger)index;

/* 根据新闻列表 URL 数组下标取 model 对象数据的个数 */
- (NSInteger)countOfModelsWithNewsListURLStringDicKey:(NSString *)newsListURLStringKey;

@end
