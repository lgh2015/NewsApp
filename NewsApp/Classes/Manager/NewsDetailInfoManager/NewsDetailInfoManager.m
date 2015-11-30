//
//  NewsDetailInfoManager.m
//  NewsApp
//
//  Created by lanou on 15/11/13.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import "NewsDetailInfoManager.h"
#import "AFURLSessionManager.h"

@interface NewsDetailInfoManager ()

@property(nonatomic,strong)NSMutableArray *labelArr;
@property(nonatomic,strong)NSMutableArray *imageUrlArr;
@property(nonatomic,strong)NSString *titleLabel;
@property(nonatomic,strong)NSMutableArray *slidesImageArr;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSMutableArray *slidesDescriptionArr;
@property(nonatomic,strong)NewsDetailModel *model;

@end

@implementation NewsDetailInfoManager

+(instancetype)shareDetailInfoManager
{
    static NewsDetailInfoManager *detailmanager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        detailmanager =[[NewsDetailInfoManager alloc]init];
    });
    return detailmanager;
}

-(void)acquireDataWithDetailUrl:(NSURL *)detailUrl Completion:(void (^)())completion

{
    __block NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager=[[AFURLSessionManager alloc]initWithSessionConfiguration:config];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:detailUrl];
    NSURLSessionDataTask *dataTask=[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        dic=responseObject;
        
        self.model=[[NewsDetailModel alloc]init];
        [self.model setValuesForKeysWithDictionary:dic [@"body"]];
        
        
        if ([[dic[@"body"] allKeys] containsObject:@"slides"]) {
            NSMutableArray *slidesImgArr=[dic[@"body"]  objectForKey:@"slides"];
            self.slidesImageArr = [[NSMutableArray alloc]init];
            self.slidesDescriptionArr =[[NSMutableArray alloc]init];
            
            for (NSDictionary *dic in slidesImgArr) {
                NSString *s1=[dic objectForKey:@"image"];
                [self.slidesImageArr addObject:s1];
                self.title=[dic objectForKey:@"title"];
                NSString *s3=[dic objectForKey:@"description"];
                [self.slidesDescriptionArr addObject:s3];
            }
            self.model.slidesImageArr = self.slidesImageArr;
            self.model.slidesTitle = self.title;
            self.model.slidesDescriptionArr = self.slidesDescriptionArr;
        }
        else{
            NSMutableArray *imgarr=[dic[@"body"]  objectForKey:@"img"];
            self.imageUrlArr=[[NSMutableArray alloc]init];
            for (NSDictionary *ddic in imgarr) {
                NSString *urlStr=[ddic objectForKey:@"url"];
                [self.imageUrlArr addObject:urlStr];
                self.model.imageArr=self.imageUrlArr;
            }
        }
        completion();
    }];
    [dataTask resume];
}


-(id)modelrrrr
{
    return self.model;
}


@end
