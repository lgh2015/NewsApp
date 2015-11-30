//
//  NewsListTableViewCell.m
//  LLF_News
//
//  Created by XiaoHuiHui on 15/11/10.
//  Copyright © 2015年 User. All rights reserved.
//

#import "NewsListTableViewCell.h"

@implementation NewsListTableViewCell

- (NewsListModel *)newsList
{
    if (!_newsList) {
        self.newsList = [[NewsListModel alloc]init];
    }
    return _newsList;
}

#pragma -mark 设置标题的方法
- (void)setTitleLabelMethodWithCGRect:(CGRect)CGRect
{
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRect];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
}

#pragma -mark 设置更新时间的方法
- (void)setUpDateTimeLabelMethodWithCGRect:(CGRect)CGRect
{
    self.updateTimeLabel = [[UILabel alloc]initWithFrame:CGRect];
    self.updateTimeLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    self.updateTimeLabel.numberOfLines = 0;
    self.updateTimeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.updateTimeLabel];
}

#pragma -mark 设置评论数的方法
- (void)setCommentsLabelMethodWithCGRect:(CGRect)CGRect
{
    self.commentsLabel = [[UILabel alloc]initWithFrame:CGRect];
    self.commentsLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    self.commentsLabel.numberOfLines = 0;
    self.commentsLabel.textAlignment = NSTextAlignmentRight;
    self.commentsLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.commentsLabel];
}

#pragma -mark 设置主图片的方法
- (void)setMyImageViewMethodWithCGRect:(CGRect)CGRect
{
    self.myImageView = [[UIImageView alloc]initWithFrame:CGRect];
    [self.contentView addSubview:self.myImageView];
    
}

- (void)setIImageViewMethodWithCGRect:(CGRect)CGRect
{
    self.iImageView = [[UIImageView alloc]initWithFrame:CGRect];
    [self.contentView addSubview:self.iImageView];
}

- (void)setMineImageViewMethodWithCGRect:(CGRect)CGRect
{
    self.mineImageView = [[UIImageView alloc]initWithFrame:CGRect];
    [self.contentView addSubview:self.mineImageView];
}

#pragma -mark 设置评论图片
- (void)setCommentsImageViewMethodWithCGRect:(CGRect)CGRect
{
    self.commentsImageView = [[UIImageView alloc]initWithFrame:CGRect];
    [self.contentView addSubview:self.commentsImageView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
