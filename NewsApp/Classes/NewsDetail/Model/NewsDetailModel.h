//
//  detailModel.h
//  LLF_News
//
//  Created by 李国灏 on 15/11/7.
//  Copyright © 2015年 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NewsDetailModel : NSObject

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *editTime;
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)NSArray *imageArr;

//幻灯片的图片
@property(nonatomic,strong)NSArray *slidesImageArr;
@property(nonatomic,strong)NSString *slidesTitle;
@property(nonatomic,strong)NSMutableArray *slidesDescriptionArr;
//title:标题
//editTime:时间
//shareurl:分享链接
//text:内容



@end
