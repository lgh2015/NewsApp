//
//  NewsListWithImagesCell.m
//  LLF_News
//
//  Created by lanou on 15/11/10.
//  Copyright © 2015年 User. All rights reserved.
//

#import "NewsListWithImagesCell.h"

@implementation NewsListWithImagesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /* 一个标题和3张图片, cell高度为100 */
        [self setTitleLabelMethodWithCGRect:CGRectMake(10, 5, kScreenWidth - 20, 20)];
        
        [self setMyImageViewMethodWithCGRect:CGRectMake(10 , 30, kImageWidth, kImageWidth * 9 / 16)];
        [self setIImageViewMethodWithCGRect:CGRectMake(10 + (kImageWidth + 5), 30, kImageWidth, kImageWidth * 9 / 16)];
        [self setMineImageViewMethodWithCGRect:CGRectMake(10 + 2 * (kImageWidth + 5), 30, kImageWidth, kImageWidth * 9 / 16)];
        
        [self setUpDateTimeLabelMethodWithCGRect:CGRectMake(10, 30 + kImageWidth * 9 / 16 + 5, kImageWidth * 2, 10)];
        [self setCommentsLabelMethodWithCGRect:CGRectMake((kScreenWidth - 25) - kImageWidth / 2 , 30 + kImageWidth * 9 / 16 + 5, kImageWidth / 2, 10)];
        [self setCommentsImageViewMethodWithCGRect:CGRectMake(kScreenWidth - 25, 30 + kImageWidth * 9 / 16 + 5, 15, 10)];
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
