//
//  GetUrlSession.h
//  AirspaceProject
//
//  Created by 徐士友 on 2018/7/25.
//  Copyright © 2018年 AirspaceProject. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Haget)(NSDictionary * data ,NSError *error ,NSHTTPURLResponse *response);
@interface GetUrlSession : NSObject
+(GetUrlSession *)shareUrlconnection;

/**
 GET
 
 @param urlString 接口
 @param isAlert 是否提示错误
 @param success 成功回调
 @param serviceFail 服务器错误回调
 @param onlineFail 网络错误回调
 */
+(void)connetion:(NSString *)urlString isAlert:(BOOL)isAlert success:(void(^)(NSDictionary *dic))success serviceFail:(void(^_Nullable)( NSString * _Nullable error))serviceFail
      onlineFail:(void(^_Nullable)( NSError * _Nullable error))onlineFail;



@end
