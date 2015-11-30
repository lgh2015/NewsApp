//
//  imageScrollView.h
//  NewsApp
//
//  Created by 李国灏 on 15/11/16.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageScrollView : UIScrollView
@property (nonatomic, retain) UIImageView *imageView;

@property(nonatomic,assign)NSInteger currenpage;


- (instancetype)initWithFrame:(CGRect)frame;
@end
