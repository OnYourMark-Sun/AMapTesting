//
//  NSData+AES.h
//  iOS_AES
//
//  Created by FM-13 on 16/6/8.
//  Copyright © 2016年 cong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)


//加密
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;


//解密
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;



@end
