//
//  NewsDetailInfoManager.h
//  NewsApp
//
//  Created by lanou on 15/11/13.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsDetailModel.h"

@interface NewsDetailInfoManager : NSObject

+ (instancetype)shareDetailInfoManager;   // 单例, 便利构造器

- (void)acquireDataWithDetailUrl:(NSURL *)detailUrl Completion:(void (^)())completion;

- (id)modelrrrr;

@end
