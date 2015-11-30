//
//  RootViewController.h
//  NewsApp
//
//  Created by lanou on 15/11/11.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (nonatomic, strong) UIScrollView *backgroundScrollView;           // 底层滚动视图
@property (nonatomic, strong) NSMutableArray *newsListTypeNameArr;          // 存放新闻列表分类名称的数组

@end
