//
//  NewsListTableViewCell.h
//  LLF_News
//
//  Created by XiaoHuiHui on 15/11/10.
//  Copyright © 2015年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "NewsListModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width        // 屏幕的宽度
#define kImageWidth ((kScreenWidth - 10 - 10 + 5) / 3 - 5)          // 图片宽度

@interface NewsListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UIImageView *iImageView;
@property (nonatomic, strong) UIImageView *mineImageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;
@property (nonatomic, strong) UILabel *commentsLabel;
@property (nonatomic, strong) UIImageView *commentsImageView;
@property (nonatomic, strong) NewsListModel *newsList;

- (void)setTitleLabelMethodWithCGRect:(CGRect)CGRect;
- (void)setUpDateTimeLabelMethodWithCGRect:(CGRect)CGRect;
- (void)setCommentsLabelMethodWithCGRect:(CGRect)CGRect;
- (void)setCommentsImageViewMethodWithCGRect:(CGRect)CGRect;

- (void)setMyImageViewMethodWithCGRect:(CGRect)CGRect;
- (void)setIImageViewMethodWithCGRect:(CGRect)CGRect;
- (void)setMineImageViewMethodWithCGRect:(CGRect)CGRect;


@end
