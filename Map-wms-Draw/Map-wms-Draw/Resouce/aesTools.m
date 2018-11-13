//
//  aesTools.m
//  Map-wms-Draw
//
//  Created by 徐士友 on 2018/9/7.
//  Copyright © 2018年 xujiahui. All rights reserved.
//

#import "aesTools.h"
#import "GTMBase64.h"
#import "NSData+AES.h"

#import <iconv.h>

//若key为空  内部数据，不易公开，需要自己补充;
static NSString *  keys = @"kakAkeke";


@implementation aesTools
+(NSData*)StringToAESWith:(NSString*)string{
    
    NSData * data1 =[string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData * data2 = [data1 AES128EncryptWithKey:keys iv:keys];
    
   
    return data2;
}

+(NSString*)AESToString:(NSData*)data{
    
    NSData * data2 = [data AES128DecryptWithKey:keys iv:keys];
    NSString * str  =[[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];

    
    return str;
}

@end
