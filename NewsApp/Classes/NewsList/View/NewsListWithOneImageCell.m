//
//  NewsListWithOneImageCell.m
//  LLF_News
//
//  Created by lanou on 15/11/10.
//  Copyright © 2015年 User. All rights reserved.
//

#import "NewsListWithOneImageCell.h"

@implementation NewsListWithOneImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /* 一个标题和一张图片 cell高度为80 */
        [self setMyImageViewMethodWithCGRect:CGRectMake(10, 5, kImageWidth, kImageWidth * 9 / 16)];
        
        [self setTitleLabelMethodWithCGRect:CGRectMake(10 + kImageWidth + 5, 5, kScreenWidth - 20 - kImageWidth - 5, 37)];
        
        [self setUpDateTimeLabelMethodWithCGRect:CGRectMake(10 + kImageWidth + 5, 5 + kImageWidth * 9 / 16 - 10, kImageWidth * 3 / 2, 10)];
        [self setCommentsLabelMethodWithCGRect:CGRectMake((kScreenWidth - 25) - kImageWidth / 2 , 5 + kImageWidth * 9 / 16 - 10, kImageWidth / 2, 10)];
        [self setCommentsImageViewMethodWithCGRect:CGRectMake(kScreenWidth - 25, 5 + kImageWidth * 9 / 16 - 10, 15, 10)];
    }
    return self;
}

@end
