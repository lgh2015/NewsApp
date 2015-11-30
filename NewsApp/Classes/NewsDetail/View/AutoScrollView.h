//
//  AutoScrollView.h
//  AutoScrollView
//
//  Created by 李国灏 on 15/11/5.
//  Copyright © 2015年 LiGuoHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageScrollView.h"
#import "NewsDetailViewController.h"

@interface AutoScrollView : UIView <UIScrollViewDelegate>

//设置scrollView
@property(nonatomic,strong)UIScrollView *scrollView;

-(instancetype)initWithFrame:(CGRect)frame Array:(NSMutableArray *)muArr;

@end
