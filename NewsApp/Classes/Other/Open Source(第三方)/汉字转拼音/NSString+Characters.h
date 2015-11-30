//
//  NSString+Characters.h
//  AddressBook
//
//  Created by liuhaiyang on 15/4/14.
//  Copyright (c) 2015年 liuhaiyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Characters)

//汉字转换为拼音
- (NSString *)pinyinOfName;

//汉字转换为拼音后，返回大写的首字母
- (NSString *)firstCharacterOfName;

@end
