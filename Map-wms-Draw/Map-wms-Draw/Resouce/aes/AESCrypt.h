/*
 #import "GTMBase64.h"
 #import "CusMD5.h"
 #import "AESCrypt.h"
 
 GTMBase64.m    -fno-objc-arc  
 
 //MD5加密
 let str = CusMD5.md5String("12345")
 //base64加密
 let data = "12345".dataUsingEncoding(NSUTF8StringEncoding)
 let data5 = GTMBase64.encodeData(data)
 let str2 = String(data: data5,encoding:NSUTF8StringEncoding)!
 //base64解密
 let data3 = GTMBase64.decodeData(data5)
 let str4 = String(data: data3,encoding:NSUTF8StringEncoding)!
 //aes加密
 let str3 = AESCrypt.encrypt("12345", password: "secret")
 //aes解密
 let str5 = AESCrypt.decrypt(str3, password: "secret")
 */

#import <Foundation/Foundation.h>

@interface AESCrypt : NSObject

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password;
+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password;

@end
