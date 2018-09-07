//
//  WMSTileOverlayUtil.m
//  AirspaceProject
//
//  Created by 徐士友 on 2018/8/23.
//  Copyright © 2018年 AirspaceProject. All rights reserved.
//

#import "WMSTileOverlayUtil.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <math.h>
#import <AFNetworking.h>
@implementation WMSTileOverlayUtil
{
    NSString *  rootURL;
    NSInteger   titleSize;           // = 256
    double      initialResolution;   // = 156543.03392804062;//2*Math.PI*6378137/titleSize;
    double      originShift;         // = 20037508.342789244;//2*Math.PI*6378137/2.0; 周长的一半
    double      HALF_PI;             // = Math.PI / 2.0;
    double      RAD_PER_DEGREE;      // = Math.PI / 180.0;
    double      METER_PER_DEGREE;    // = originShift / 180.0;//一度多少米
    double      DEGREE_PER_METER;    // = 180.0 / originShift;//一米多少度
}

- (id)initWithRootURL:(NSString *)rootRUL {
    self = [super init];
    if (self) {
        rootURL = rootRUL;
        titleSize = 256;
        initialResolution = 156543.03392804062;
        originShift = 20037508.342789244;
        HALF_PI = M_PI_2;
        RAD_PER_DEGREE = M_PI / 180.0;
        METER_PER_DEGREE = originShift / 180.0;
        DEGREE_PER_METER = 180.0 / originShift;
    }
    return self;
}

/**
 * @brief 以tile path生成URL。用于加载tile,此方法默认填充URLTemplate
 * @param path tile path
 * @return 以tile path生成tileOverlay
 */
- (NSURL *)URLForTilePath:(MATileOverlayPath)path {
    
    NSString * strURL = [[NSString alloc] initWithFormat:@"%@%@", rootURL, [self titleBoundsByX:path.x
                                                                                              Y:path.y
                                                                                              Z:path.z]];
    NSURL * url = [NSURL URLWithString:strURL];
    return url;
}

/**
 * @brief 加载被请求的tile,并以tile数据或加载tile失败error访问回调block;默认实现为首先用URLForTilePath去获取URL,然后用异步NSURLConnection加载tile
 * @param path   tile path
 * @param result 用来传入tile数据或加载tile失败的error访问的回调block
 */
- (void)loadTileAtPath:(MATileOverlayPath)path result:(void (^)(NSData *tileData, NSError *error))result {
    if (path.z < 8) return;
    NSURL * url = [self URLForTilePath:path];
    NSString * strURL = url.absoluteString;
    
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] init];
    AFHTTPResponseSerializer *serializer=[AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"image/png"];
    manager.responseSerializer = serializer;
    [manager GET:strURL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             UIImage * image = [UIImage imageWithData:responseObject];
             NSData * data = UIImagePNGRepresentation(image);
             result(data, nil);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              result(nil, error);
         }
     ];
    
//    AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] init];
//    AFHTTPResponseSerializer *serializer=[AFHTTPResponseSerializer serializer];
//    serializer.acceptableContentTypes = [NSSet setWithObject:@"image/png"];
//    manager.responseSerializer = serializer;
//
//
//    [manager GET:strURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        UIImage * image = [UIImage imageWithData:responseObject];
//        NSData * data = UIImagePNGRepresentation(image);
//        result(data, nil);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//         result(nil, error);
//    }];
    
    
}



/**
 * @brief 取消请求瓦片，当地图显示区域发生变化时，会取消显示区域外的瓦片的下载, 当disableOffScreenTileLoading=YES时会被调用。since 5.3.0
 * @param path  tile path
 */
- (void)cancelLoadOfTileAtPath:(MATileOverlayPath)path {
//    [super cancelLoadOfTileAtPath:path];
}

/**
 * 根据瓦片的x/y等级返回瓦片范围
 *
 * @param tx x
 * @param ty y
 * @param zoom z
 * @return url
 */
- (NSString *)titleBoundsByX:(NSInteger)tx Y:(NSInteger)ty Z:(NSInteger)zoom {
    double minX = [self pixels2Meters:(tx * titleSize) zoom:zoom];
    double maxY = -[self pixels2Meters:(ty * titleSize) zoom:zoom];
    double maxX = [self pixels2Meters:((tx + 1) * titleSize) zoom:zoom];
    double minY = -[self pixels2Meters:((ty + 1) * titleSize) zoom:zoom];
    
    //转换成经纬度
    minX = [self meters2Lon:minX];
    minY = [self meters2Lat:minY];
    maxX = [self meters2Lon:maxX];
    maxY = [self meters2Lat:maxY];
    //坐标转换工具类构造方法 Gps( WGS-84) 转 为高德地图需要的坐标
    CLLocationCoordinate2D amapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake(minY, minX), AMapCoordinateTypeGPS);
    minY = amapcoord.latitude;
    minX = amapcoord.longitude;
    
    CLLocationCoordinate2D maxAmapcoord = AMapCoordinateConvert(CLLocationCoordinate2DMake(maxY, maxX), AMapCoordinateTypeGPS);
    maxY = maxAmapcoord.latitude;
    maxX = maxAmapcoord.longitude;
    NSString * result = [[NSString alloc] initWithFormat:@"%f,%f,%f,%f&width=256&height=256", minX, minY, maxX, maxY];
    return result;
}

/**
 * 根据像素、等级算出坐标
 *
 * @param p p
 * @param zoom z
 * @return double
 */
- (double)pixels2Meters:(NSInteger)p zoom:(NSInteger)zoom {
    return p * [self resolution:zoom] - originShift;
}

/**
 * 计算分辨率
 *
 * @param zoom z
 * @return double
 */
- (double)resolution:(NSInteger)zoom {
    return initialResolution / (pow(2, zoom));
}

/**
 * X米转经纬度
 */
- (double)meters2Lon:(double)mx {
    double lon = mx * DEGREE_PER_METER;
    return lon;
}

/**
 * Y米转经纬度
 */
- (double)meters2Lat:(double)my {
    double lat = my * DEGREE_PER_METER;
    lat = 180.0 / M_PI * (2 * atan(exp(lat * RAD_PER_DEGREE)) - HALF_PI);
    return lat;
}

@end
