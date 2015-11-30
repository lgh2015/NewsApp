//
//  NewsDetailViewController.m
//  LLF_News
//
//  Created by lanou on 15/11/9.
//  Copyright © 2015年 User. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsDetailInfoManager.h"
#import "NewsDetailModel.h"
#import "MBProgressHUD+MJ.h"
#import "AutoScrollView.h"

#define k_ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define k_ScreenHeight     [UIScreen mainScreen].bounds.size.height

@interface NewsDetailViewController () <UIScrollViewDelegate>

@property(nonatomic,strong)AutoScrollView *autoScrollV;
@property(nonatomic,strong)UIView *slidesView;
@property(nonatomic,strong)UIView *labelView;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)CGFloat imgViewHeight;
@property(nonatomic,strong)MBProgressHUD *mub;
@property(nonatomic,strong)NSMutableArray *imgArr;
@property(nonatomic,strong)NewsDetailModel *model;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *pageLabel;
//记录label的高度
@property(nonatomic,assign)CGFloat labelH;

@end

@implementation NewsDetailViewController

-(NSMutableArray *)imgArr
{
    if (!_imgArr) {
        _imgArr=[[NSMutableArray alloc]init];
    }
    return _imgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor colorWithRed:27/255 green:27/255 blue:27/255 alpha:1];
    //加载等待图
    [self addMBProgressHUD];
    [[NewsDetailInfoManager shareDetailInfoManager]acquireDataWithDetailUrl :[NSURL URLWithString:self.detailUrl] Completion:^{
         self.model=[[NewsDetailInfoManager shareDetailInfoManager]modelrrrr];
        if (!self.model.slidesImageArr) {
            //一张照片的方法
            [self onePictureDetailView];
        }
        else
        {
            //幻灯片的方法
            [self slidesViewAciton];
        }
    }];
}

#pragma mark--幻灯片页面的方法
-(void)slidesViewAciton
{
    self.slidesView=[[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.slidesView];
    NSMutableArray *imgARR=[[NSMutableArray alloc]init];
    for (NSString *urlStr in self.model.slidesImageArr) {
        [imgARR addObject:urlStr];
    }
    
    self.autoScrollV=[[AutoScrollView alloc]initWithFrame:CGRectMake(k_ScreenWidth/375*15, k_ScreenHeight*3/25, k_ScreenWidth- k_ScreenWidth/375*30, k_ScreenHeight/2) Array:imgARR];
    self.autoScrollV.scrollView.delegate=self;
    [self.slidesView addSubview:self.autoScrollV];
    
    self.labelView=[[UIView alloc]initWithFrame:CGRectMake(10,k_ScreenHeight*3/17+k_ScreenHeight/2 , k_ScreenWidth, k_ScreenHeight)];
    self.labelView.backgroundColor=[UIColor clearColor];
    self.labelView.userInteractionEnabled=YES;
    [self.slidesView addSubview:self.labelView];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 0, 0)];
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.textColor=[UIColor lightGrayColor];
    self.titleLabel.text=@"";
    self.titleLabel.text=[self.titleLabel.text stringByAppendingFormat:@"%@\n\n%@",self.model.title,self.model.slidesDescriptionArr[self.currentPage]];
    
    CGFloat titleW=self.slidesView.frame.size.width/375*300;
    CGSize size=CGSizeMake(titleW, 0);
    CGRect titleSize = [self.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    self.titleLabel.numberOfLines = 0;
    
    self.titleLabel.frame = CGRectMake(5, 5, titleW, titleSize.size.height);
    [self.labelView addSubview:self.titleLabel];
    
    UIPanGestureRecognizer *panGestureR=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(PanGestureRecognizerAction:)];
    [self.labelView addGestureRecognizer:panGestureR];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(k_ScreenWidth/375*320, k_ScreenHeight/667*450, 1, k_ScreenWidth/375*160)];
    lineLabel.backgroundColor=[UIColor lightGrayColor];
    [self.slidesView addSubview:lineLabel];
    
    self.pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(k_ScreenWidth/375*323, k_ScreenHeight/667*455, k_ScreenWidth/375*49, k_ScreenWidth/375*30)];
    self.pageLabel.backgroundColor=[UIColor clearColor];
    self.pageLabel.textColor=[UIColor lightGrayColor];
    self.pageLabel.text=[NSString stringWithFormat:@"%d/%ld",self.currentPage + 1,(unsigned long)self.model.slidesImageArr.count];
    [self.slidesView addSubview:self.pageLabel];
    
    [self addBackButton:self.slidesView];
    [self.mub hide:YES];
}

#pragma mark---拖拽手势
-(void)PanGestureRecognizerAction:(UIPanGestureRecognizer *)pan
{
    UIView *labelV=pan.view;
    CGPoint point=[pan  translationInView:labelV];
    if (labelV.frame.origin.y<k_ScreenHeight/667*30) {
        labelV.frame=CGRectMake(0, k_ScreenHeight/667*30+1, k_ScreenWidth, k_ScreenHeight);
    }
        if (labelV.frame.origin.y<k_ScreenHeight/667*500) {
    labelV.transform = CGAffineTransformTranslate(labelV.transform, 0, point.y);
    [pan  setTranslation:CGPointZero inView:labelV];
    }
    if (labelV.frame.origin.y>k_ScreenHeight/667*500-1) {
        labelV.frame=CGRectMake(0, k_ScreenHeight/667*500-1, k_ScreenWidth, k_ScreenHeight);
    }
}

#pragma mark---返回键
-(void)addBackButton:(UIView *)view
{
    //返回按钮
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(5 , 27, 35, 35)];
    btn.backgroundColor=[UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"iconfont-fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
}

#pragma mark--返回键触发方法
-(void)buttonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark--一张照片的详情页
-(void)onePictureDetailView
{
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, k_ScreenWidth, k_ScreenHeight)];
    self.scrollView.showsHorizontalScrollIndicator=NO;
    
    [self.view addSubview:self.scrollView];
    
    //标题
     self.model=[[NewsDetailInfoManager shareDetailInfoManager]modelrrrr];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, k_ScreenWidth-20, k_ScreenHeight/10)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=[UIColor colorWithRed:111/255.0 green:133/255.0 blue:165/255.0 alpha:1];
    titleLabel.text=self.model.title;
    titleLabel.numberOfLines=0;
    //加粗
    titleLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.scrollView addSubview:titleLabel];
    
    //时间
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, k_ScreenHeight/10, k_ScreenWidth/2, k_ScreenHeight/20)];
    timeLabel.text=self.model.editTime;
    timeLabel.textColor=[UIColor grayColor];
    timeLabel.font=[UIFont systemFontOfSize:14];
    [self.scrollView addSubview:timeLabel];
    
    //轮播图
    for (NSString  *imgUrl in self.model.imageArr) {

        [self.imgArr addObject:imgUrl];
        self.imgViewHeight=k_ScreenHeight/3.5;
    }
    AutoScrollView *autoSV=[[AutoScrollView alloc]initWithFrame:CGRectMake(k_ScreenWidth/25, k_ScreenHeight*3/17, k_ScreenWidth-k_ScreenWidth/25*2, k_ScreenHeight/3.5) Array:self.imgArr];
    autoSV.scrollView.scrollsToTop=NO;
    [self.scrollView addSubview:autoSV];
    autoSV.tag=10010;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerAciton:)];
    [autoSV.scrollView addGestureRecognizer:tap];
    
    UILabel *pagelabel=[[UILabel alloc]initWithFrame:CGRectMake(k_ScreenWidth/375*320, timeLabel.frame.origin.y, k_ScreenWidth/375*50 , k_ScreenWidth/375*30)];
    pagelabel.backgroundColor=[UIColor clearColor];
    pagelabel.textColor=[UIColor grayColor];
    pagelabel.textAlignment=NSTextAlignmentCenter;
    pagelabel.tag=10086;
    pagelabel.text=[NSString stringWithFormat:@"%.0f/%ld",autoSV.scrollView.contentOffset.x/(k_ScreenWidth-k_ScreenWidth/25*2)+1,(unsigned long)self.model.imageArr.count];
    if (self.model.imageArr.count!=0) {
        [self.scrollView addSubview:pagelabel];
    }
    autoSV.scrollView.delegate=self;
    
    //截取text内容有用的部分
    NSArray *arr=[[NSArray alloc]init];
    if ([self.newsListTypeName isEqualToString:@"娱乐"]) {
        arr=[self.model.text componentsSeparatedByString:@"</p> <"];
    }
    else{
        arr=[self.model.text componentsSeparatedByString:@"</p><"];
    }
    self.labelH=0;
    for (int i =0; i<arr.count; i++)
    {
        if ([arr[i] length]>5)
        {
            if ([self isChinese:[arr[i] substringWithRange:NSMakeRange(5, 1)]]||[self isChinese:[arr[i] substringWithRange:NSMakeRange(3, 1)]])
            {
                UILabel *label=[[UILabel alloc]init];
                label.textColor=[UIColor  colorWithRed:111/255.0 green:133/255.0 blue:165/255.0 alpha:1];
                label.text=@"";

                if (i==0) {
                    label.text=[arr[i] substringFromIndex:3];
                }
                else if (i==arr.count-1)
                {
                    label.text=[arr[i] substringWithRange:NSMakeRange(2, [arr[i] length]-6)];
                }
                else
                {
                    label.text=[arr[i] substringFromIndex:2];
                }
                //文字的自适应
                label.numberOfLines=0;
                NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
                CGFloat contentW = self.view.bounds.size.width - k_ScreenHeight/33;
                CGSize si=CGSizeMake(contentW, 0);
                CGRect labelSize=[label.text boundingRectWithSize:si options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                
                CGFloat contentH = labelSize.size.height;
                label.frame=CGRectMake(10, titleLabel.frame.size.height+timeLabel.frame.size.height+self.imgViewHeight+self.labelH+k_ScreenHeight/18, contentW, contentH);
                
                self.labelH=self.labelH+contentH+k_ScreenHeight/33;
                [self.scrollView addSubview:label];
            }
        }
    }
    self.scrollView.contentSize=CGSizeMake(k_ScreenWidth, self.labelH+k_ScreenHeight/10+k_ScreenHeight/20+self.imgViewHeight+k_ScreenHeight/3.8);
    
    //返回按钮
    UINavigationController *navi=[[UINavigationController alloc]init];
    [self.view addSubview:navi.navigationBar];
    [navi.navigationBar setBackgroundColor:[UIColor blackColor]];
    navi.navigationBar.frame=CGRectMake(0, 0, k_ScreenWidth, 64);
    navi.navigationBar.barTintColor=[UIColor colorWithRed:0 green:0 blue:0.12 alpha:0.5];
    
    [self addBackButton:self.view];
    //分享按钮
    [self.mub hide:YES];
}

#pragma mark--点击图片查看大图的手势方法
-(void)tapGestureRecognizerAciton:(UIGestureRecognizer *)sender
{
    UIView *whiteView=[[UIView alloc]initWithFrame:self.view.bounds];
    whiteView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    [self.view addSubview:whiteView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelTapAciton:)];
    [whiteView  addGestureRecognizer:tap];
    
    AutoScrollView *autoSV=[[AutoScrollView alloc]initWithFrame:CGRectMake(0, k_ScreenHeight/4, k_ScreenWidth, k_ScreenHeight/1.8) Array:self.imgArr];
    UIScrollView *scorllV=(UIScrollView *)sender.view;
    CGFloat contentOffSet=(scorllV.contentOffset.x/(k_ScreenWidth-k_ScreenWidth/25*2))*k_ScreenWidth;
    autoSV.scrollView.contentOffset=CGPointMake(contentOffSet, 0) ;
    autoSV.scrollView.scrollsToTop=NO;
    
    [whiteView addSubview:autoSV];
}

#pragma mark--再次点击取消大图模式
-(void)cancelTapAciton:(UIGestureRecognizer *)sender
{
    [sender.view removeFromSuperview];
}

-(void)addMBProgressHUD
{
    //菊花图
    self.mub = [[MBProgressHUD alloc]initWithFrame:CGRectMake(100, 300, 50, 50)];
    [self.view addSubview:self.mub];
    [self.mub show:YES];
}

#pragma mark--判断是否中文
-( BOOL )isChinese:( NSString *)c{
    int strlength = 0 ;
    char * p = ( char *)[c cStringUsingEncoding : NSUnicodeStringEncoding ];
    for ( int i= 0 ; i<[c lengthOfBytesUsingEncoding : NSUnicodeStringEncoding ] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return ((strlength/ 2 )== 1 )? YES : NO ;
}

#pragma mark--scrollView的执行方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.autoScrollV.scrollView) {
    self.currentPage = (int)self.autoScrollV.scrollView.contentOffset.x/ (int)self.autoScrollV.scrollView.frame.size.width;
    }
    UILabel *la=[self.scrollView viewWithTag:10086];
    AutoScrollView *ss=[self.scrollView viewWithTag:10010];
    la.text=[NSString stringWithFormat:@"%.0f/%ld",ss.scrollView.contentOffset.x/(k_ScreenWidth-k_ScreenWidth/25*2)+1,(unsigned long)self.model.imageArr.count];
    
    if (self.currentPage==0&&[scrollView isEqual: self.autoScrollV.scrollView]) {
        
        self.titleLabel.text=@"";

        self.titleLabel.text=[self.titleLabel.text stringByAppendingFormat:@"%@\n\n%@",self.model.title,self.model.slidesDescriptionArr[self.currentPage] ];
        
        CGFloat titleW=self.slidesView.frame.size.width/375*300;
        CGSize size=CGSizeMake(titleW, 0);
        CGRect titleSize = [self.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
        self.titleLabel.numberOfLines = 0;
        
        self.titleLabel.frame = CGRectMake(5, 5, titleW, titleSize.size.height);
        
        self.pageLabel.text=[NSString stringWithFormat:@"%d/%ld",self.currentPage+1,(unsigned long)self.model.slidesImageArr.count];
    }
    else if(self.currentPage!=0&&[scrollView isEqual: self.autoScrollV.scrollView])
    {
        self.titleLabel.text=self.model.slidesDescriptionArr[self.currentPage];
    
        CGFloat titleW=self.slidesView.frame.size.width/375*300;
        CGSize size=CGSizeMake(titleW, 0);
        CGRect titleSize = [self.titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
        self.titleLabel.numberOfLines = 0;     
        self.pageLabel.text=[NSString stringWithFormat:@"%d/%ld", self.currentPage + 1, (unsigned long)self.model.slidesImageArr.count];
        self.pageLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.frame = CGRectMake(5, 5, titleW, titleSize.size.height);
    }
    
    if ([scrollView isEqual:self.autoScrollV.scrollView]) {
        NSArray *avc=[self.autoScrollV.scrollView subviews];
        //缩放后让上一张回到原来的大小
        for (int i=0 ; i<self.model.slidesImageArr.count; i++) {
            if ((i)!=self.currentPage) {
                [avc[i] setZoomScale:1];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
