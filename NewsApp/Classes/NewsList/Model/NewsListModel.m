//
//  NewsListModel.m
//  NewsApp
//
//  Created by lanou on 15/11/11.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import "NewsListModel.h"

@implementation NewsListModel

+ (instancetype)newsListInfoWithDictionary:(NSDictionary *)dic
{
    NewsListModel *newsList = [[NewsListModel alloc]init];
    
    newsList.thumbnail = dic[@"thumbnail"];
    newsList.title = dic[@"title"];
    
    NSRange range = {5, 11};
    newsList.updateTime = [dic[@"updateTime"] substringWithRange:range];
    
    newsList.detailUrl = dic[@"id"];
    newsList.type = dic[@"type"];
    newsList.online = dic[@"online"];
    newsList.commentsUrl = dic[@"commentsUrl"];
    
    newsList.style = [NSDictionary dictionary];
    newsList.style = dic[@"style"];
    newsList.link = [NSDictionary dictionary];
    newsList.link = dic[@"link"];
    newsList.links = [NSArray array];
    newsList.links = dic[@"links"];
    newsList.likes = [[NSNumber alloc]init];
    newsList.likes = dic[@"likes"];
    newsList.img = [NSArray array];
    newsList.img = dic[@"img"];
    
    if (dic[@"comments"] != nil) {
        newsList.comments = [NSString stringWithFormat:@"%@", dic[@"comments"]];
    }
    
    newsList.imageArr = [NSMutableArray array];
    if (![newsList.thumbnail isEqualToString: @""]) {
        newsList.imageArr = [NSMutableArray array];
        [newsList.imageArr addObject:newsList.thumbnail];
    }
    else if ([dic[@"style"] objectForKey:@"images"] != nil)
    {
        newsList.imageArr = [NSMutableArray array];
        NSArray *arr = [NSArray arrayWithObject:[newsList.style objectForKey:@"images"]];
        for (NSString *imageUrl in arr[0]) {
            [newsList.imageArr addObject:imageUrl];
        }
    }
    else if (newsList.img != nil && ![[newsList.img[0] objectForKey:@"url"] isEqualToString:@""]){
        [newsList.imageArr addObject:[newsList.img[0] objectForKey:@"url"]];
    }
    
    return newsList;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
