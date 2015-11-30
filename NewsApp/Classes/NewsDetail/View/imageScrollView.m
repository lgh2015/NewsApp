//
//  imageScrollView.m
//  NewsApp
//
//  Created by 李国灏 on 15/11/16.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import "imageScrollView.h"
@interface imageScrollView () <UIScrollViewDelegate>


@end
@implementation imageScrollView


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        self.scrollsToTop=  NO;
        self.maximumZoomScale = 4;
        self.minimumZoomScale = 0.5;
        self.delegate = self;
    }
    return  self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


@end
