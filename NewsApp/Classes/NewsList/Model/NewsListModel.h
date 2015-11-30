//
//  NewsListModel.h
//  NewsApp
//
//  Created by lanou on 15/11/11.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsListModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *detailUrl;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDictionary *style;
@property (nonatomic, strong) NSString *commentsUrl;
@property (nonatomic, strong) NSString *comments;

@property (nonatomic, strong) NSNumber *online;         // 0 为直播或专题新闻, 1 为普通新闻
@property (nonatomic, strong) NSDictionary *link;
@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, strong) NSArray *links;           // 图片分类里的属性
@property (nonatomic, strong) NSNumber *likes;          // 萌物分类里的属性
@property (nonatomic, strong) NSArray *img;             // 萌物分类里的属性 (image的URL和size)

+ (instancetype)newsListInfoWithDictionary:(NSDictionary *)dic;

@end
