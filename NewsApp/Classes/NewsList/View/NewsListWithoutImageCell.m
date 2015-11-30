//
//  NewsListWithoutImageCell.m
//  LLF_News
//
//  Created by lanou on 15/11/10.
//  Copyright © 2015年 User. All rights reserved.
//

#import "NewsListWithoutImageCell.h"

@implementation NewsListWithoutImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /* 一个标题和没有图片 cell高度为80 */
        [self setTitleLabelMethodWithCGRect:CGRectMake(10, 5, kScreenWidth - 20, 40)];
        [self setUpDateTimeLabelMethodWithCGRect:CGRectMake(10, 55, kImageWidth * 2, 10)];
        if (self.newsList.comments != 0) {
            [self setCommentsLabelMethodWithCGRect:CGRectMake((kScreenWidth - 25) - kImageWidth / 2 , 55, kImageWidth / 2, 10)];
            [self setCommentsImageViewMethodWithCGRect:CGRectMake(kScreenWidth - 35, 55, 25, 10)];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
