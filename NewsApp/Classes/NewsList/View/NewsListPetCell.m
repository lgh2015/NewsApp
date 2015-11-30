//
//  NewsListPetCell.m
//  NewsApp
//
//  Created by lanou on 15/11/13.
//  Copyright © 2015年 劳晓辉. All rights reserved.
//

#import "NewsListPetCell.h"

@implementation NewsListPetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setMyImageViewMethodWithCGRect:CGRectMake(10, 10, kScreenWidth - 20, 0)];
    }
    return self;
}

@end
