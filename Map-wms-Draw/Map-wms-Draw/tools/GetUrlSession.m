//
//  UrlConnection.m
//  AirspaceProject
//
//  Created by 徐士友 on 2018/7/25.
//  Copyright © 2018年 AirspaceProject. All rights reserved.
//

#import "GetUrlSession.h"

#import <AFNetworkReachabilityManager.h>

#import <AFNetworking.h>

static GetUrlSession *urlconnection;

@implementation GetUrlSession
+(GetUrlSession *)shareUrlconnection{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!urlconnection) {
            urlconnection = [[GetUrlSession alloc]init];
        }
        
    });
    return urlconnection;
}
//+(void)connetion:(NSString *)urlString isAlert:(BOOL)isAlert success:(void(^_Nullable)(NSDictionary *_Nullable dic))success serviceFail:(void(^_Nullable)( NSString * _Nullable error))serviceFail
//      onlineFail:(void(^_Nullable)( NSError * _Nullable error))onlineFail{
//
//    [MBProgressHUD showHUDAddedTo:[getCurrentViewControllerEx topViewController].view animated:YES];
//    //实例化AFHTTPSessionManager
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //调出请求头
////    if (yesJson) {
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
////    }else{
////        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
////    }
//
//    //将token封装入请求头
//    //验证token
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:GET_TOKEN]) {
//        //解密token
//        NSString *token = GetUserToken;
//        [manager.requestSerializer setValue:token forHTTPHeaderField:GET_TOKEN];
//
//    }
//
//    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:[getCurrentViewControllerEx topViewController].view animated:YES];
//        });
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            NSInteger result;
//            NSString * errorObject;
//
//            NSDictionary * dic = responseObject;
//            if (dic.allKeys.count<1) {
//                [MBProgressHUD hideHUDForView:[getCurrentViewControllerEx topViewController].view animated:YES];
//                return ;
//            }
//
//            result = [dic[@"code"] intValue];
//
//            if (result !=200) {
//
//                //服务器返回错误
//                //提示
//                errorObject = dic[@"msg"];
//                //总结
//                [MBProgressHUD hideHUDForView:[getCurrentViewControllerEx topViewController].view animated:YES];
//                //显示
//                if (isAlert) {
//                    //                服务器错误提示取消
//                    [MBProgressHUD showText:errorObject HUDAddedTo:[getCurrentViewControllerEx topViewController].view animated:YES afterDelay:showtime];
//
//                }
//
//
//            }else{
//
//                [MBProgressHUD hideHUDForView:[getCurrentViewControllerEx topViewController].view animated:YES];
//                //成功返回数据
//                success(dic);
//
//            }
//
//        });
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//             [MBProgressHUD hideHUDForView:[getCurrentViewControllerEx topViewController].view animated:YES];
//        });
//    }];
//
//}



+(void)connetion:(NSString *)urlString isAlert:(BOOL)isAlert success:(void(^_Nullable)(NSDictionary *_Nullable dic))success serviceFail:(void(^_Nullable)( NSString * _Nullable error))serviceFail
      onlineFail:(void(^_Nullable)( NSError * _Nullable error))onlineFail{

    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString: [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];

    request.timeoutInterval = 20;
    //缓存
    //request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    //验证token
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:GET_TOKEN]) {
//        //解密token
//      NSString *token = GetUserToken;
//        [request setValue:token forHTTPHeaderField:GET_TOKEN];
//
//    }

    NSURLSession *urlsession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlsession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {



        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;//response处理
        NSLog(@"%@",httpResponse.URL);
        NSDictionary *dic;//数据
        id errorObject;//错误
        NSInteger result;


                //不为空
                NSError *jsonToStrError;

        if (data == nil) {
            serviceFail(@"333");
            return ;
        }

                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonToStrError];

        if (jsonToStrError) {
            serviceFail(@"333");
            return;
        }
        
                     result = [dic[@"code"] intValue];

                    if (result !=200) {

                        //服务器返回错误
                        //提示
                        errorObject = dic[@"msg"];
                        //总结
                        dispatch_async(dispatch_get_main_queue(), ^{

                            //显示
                            if (isAlert) {
                                //                服务器错误提示取消
                            

                            }

                            serviceFail(@"333");
                        });

                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{

                            //成功返回数据

                            success(dic);
                        });


                    }


    }];
    //
    [dataTask resume];


}


- (BOOL)StringIsNullOrEmpty:(NSString *)str
{
    return (str == nil || [str isKindOfClass:[NSNull class]] || str.length == 0);
}



@end
