//
//  ExonerateViewController.m
//  NewsApp
//
//  Created by lanou on 15/11/17.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import "ExonerateViewController.h"

#define  KscreenWidth [UIScreen mainScreen].bounds.size.width
#define  Kscreenheight [UIScreen mainScreen].bounds.size.height

@interface ExonerateViewController ()

@end

@implementation ExonerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10 , 20, 30, 30)];
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"iconfont-fanhui.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 84, KscreenWidth - 20, 30)];
    labelTitle.backgroundColor=[UIColor clearColor];
    labelTitle.textAlignment= NSTextAlignmentCenter;
    labelTitle.font = [UIFont systemFontOfSize:20];
    
    
    
    labelTitle.text = @"免责声明";
    
    [self.view addSubview:labelTitle];
    
   
    
    UILabel*label =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, KscreenWidth-10, Kscreenheight - 50)];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.textAlignment =  NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:18];
    label.numberOfLines = 0;
    
    label.text=@"    本APP所有内容，包活文字、图片、视频、均在网上搜集。访问者可将本APP提供的内容或服务用于个人学习、研究或欣赏, 以及其他非商业性或非盈利性用途，但同时应遵守著作权法及其他相关法律的规定, 不得侵犯本APP及相关权利人的合法权利。除此以外，将本APP任何内容或服务用于其他用途时，必须征得本APP及相关权利人的书面许可。在使用本APP前, 请您务必仔细阅读并透彻理解本声明。你可以选择不使用这款产品, 但如果您使用这款产品,都将被视作已无条件接受本声明所涉全部内容。任何单位或个人认为APP内容可能涉嫌到侵犯其合法权益, 应该及时向本APP提出书面通知, 本APP作为学术交流不作为任何盈利的手段, 相关涉嫌侵权的内容, 希望告知。本APP是出于传递更多信息的目的。";
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
}

-(void)buttonAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
