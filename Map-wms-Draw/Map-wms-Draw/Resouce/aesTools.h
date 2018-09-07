//
//  aesTools.h
//  Map-wms-Draw
//
//  Created by 徐士友 on 2018/9/7.
//  Copyright © 2018年 xujiahui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface aesTools : NSObject

///把字符串 加密为aes 返回data
+(NSData*)StringToAESWith:(NSString*)string;

///把加密过的data 解密。返回 string
+(NSString*)AESToString:(NSData*)data;


@end
