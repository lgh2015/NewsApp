//
//  AutoScrollView.m
//  AutoScrollView
//
//  Created by 李国灏 on 15/11/5.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import "AutoScrollView.h"
#import "UIImageView+WebCache.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define k_ScreenHeight     [UIScreen mainScreen].bounds.size.height


@interface AutoScrollView ()
//传进来数组
@property(nonatomic,strong)NSMutableArray *muArr;
//设置定时器
@property(nonatomic,strong)NSTimer *timer;
//记录当前是哪张图片
@property(nonatomic,assign)NSInteger currentPage;

@end

@implementation AutoScrollView
#pragma mark--初始化方法

-(instancetype)initWithFrame:(CGRect)frame Array:(NSMutableArray *)muArr
{
    self=[super initWithFrame:frame];
    if (self) {
        self.muArr=muArr;
        self.currentPage=1;
        [self insertScrollView];
        [self insertImage:muArr];
    }
    return self;
}

#pragma mark--设置ScrollView
-(void)insertScrollView
{
    self.scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.contentSize=CGSizeMake((self.frame.size.width ) * self.muArr.count, self.frame.size.height);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    self.scrollView.contentOffset=CGPointMake(0,0);
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:self.scrollView];
}


#pragma mark--设置将数组里面的图片加到scrollView上
-(void)insertImage:(NSMutableArray *)muArr
{
    for (int i=0; i<muArr.count;i++)
    {
        imageScrollView *imageSV=[[imageScrollView alloc]initWithFrame:CGRectMake((self.scrollView.frame.size.width )*(i), 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [imageSV.imageView sd_setImageWithURL:[NSURL URLWithString:muArr[i]]];
//        imageSV.imageView.image =muArr[i];
        imageSV.tag=i+1;
        [self.scrollView addSubview:imageSV];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentPage=self.scrollView.contentOffset.x/self.scrollView.frame.size.width+1;
    //缩放后让上一张回到原来的大小
    for (int i=0 ; i<self.muArr.count; i++) {
        if ((i+1)!=self.currentPage) {
            imageScrollView *aa=[self.scrollView viewWithTag:i+1];
            aa.zoomScale=1;
        }
    }
}






@end
