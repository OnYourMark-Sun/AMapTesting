//
//  DrawTheTrajectoryViewController.m
//  Map-wms-Draw
//
//  Created by 徐士友 on 2018/9/6.
//  Copyright © 2018年 xujiahui. All rights reserved.
//

#import "DrawTheTrajectoryViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "GetUrlSession.h"
#define huizhiTimes 0.03
#import "aesTools.h"
#define WeakSelf  __weak typeof(self) weakSelf = self
@interface DrawTheTrajectoryViewController ()<MAMapViewDelegate>
{
    ///进行划线代码
    NSInteger huizhiNum;
    MAPolyline *commonPolyline;
    BOOL endHuizhi;
    
    NSString * string2;
}
////////划线
///显示是个点
@property(nonatomic,strong) NSMutableArray * TenPointArray ;
@property (nonatomic, strong) NSMutableArray * pointArray;
@property (nonatomic, strong) NSMutableArray * lineArray;

@property(nonatomic,strong)MAMapView *mapViewhome;
@end

@implementation DrawTheTrajectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /////////--------------没有密💊 请自行找数据 -------//////////////
    // 解析plist 获取Url
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"urldata" ofType:@"plist"]];
    //获取data 进行解密
    string2 = [aesTools AESToString:dataDict[@"URLDraw"]];
    //---------------------------------------------------------------------------------
    
    
    // Do any additional setup after loading the view.
    
    //   加载地图
    [self setMap];
    //绘制数据
    [self huizhiData];
    [self.mapViewhome setMapType:MAMapTypeStandard];
    self.pointArray=[NSMutableArray array];
    self.lineArray=[NSMutableArray array];
    
}
#pragma mark Map
-(void)setMap{
    
    ///初始化地图
    self.mapViewhome = [[MAMapView alloc] initWithFrame:self.view.frame];
    self.mapViewhome.showsCompass= NO; // 设置成NO表示关闭指南针；YES表示显示指南针
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapViewhome.showsUserLocation = NO;
    [self.mapViewhome setZoomLevel:12 animated:YES];
    self.mapViewhome.userTrackingMode = MAUserTrackingModeFollow;
    self.mapViewhome.delegate =self;
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapViewhome.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    ///把地图添加至view
    
    self.mapViewhome.mapType = MAMapTypeNavi;
    [self.view addSubview:self.mapViewhome];
    
}
#pragma mark  ---------------------------------绘制轨迹-
-(void)huizhiData{
    
    huizhiNum = 0;
    _TenPointArray = [NSMutableArray array];
    WeakSelf;
    //4257
    [GetUrlSession connetion:string2 isAlert:NO success:^(NSDictionary *dic) {
        
        NSDictionary * dic1 = dic[@"data"];
        NSArray * array1 = dic1[@"flightDetails"];
        
        for (int i=0; i<array1.count; i++) {
            
            NSDictionary * dict = array1[i];
            
            NSDictionary * di = @{@"latitude":dict[@"latitude"],@"longitude":dict[@"longitude"]};
            [weakSelf.pointArray addObject:di];
        }
        
        NSLog(@"绘制数据OOOOOOOOOOOOOOOOOOOOK");
        [weakSelf jumpPoint];
        
    } serviceFail:^(NSString * _Nullable error) {
        
    } onlineFail:^(NSError * _Nullable error) {
        
    }];
    
}


-(void)jumpPoint{
    NSDictionary * huizhiDic2 = self.pointArray[0];
    MAPointAnnotation * a1= [[MAPointAnnotation alloc] init];
    a1.coordinate = CLLocationCoordinate2DMake([huizhiDic2[@"latitude"] doubleValue], [ huizhiDic2[@"longitude"] doubleValue]);
    
    [self.mapViewhome showAnnotations:@[a1] animated:YES];
    
    [self performSelector:@selector(mapViewHUIZHI) withObject:nil afterDelay:2];
    
}

- (void)mapViewHUIZHI{
    
    huizhiNum += 3;
    if (huizhiNum>(_pointArray.count-4)) {
        huizhiNum =_pointArray.count-1;
        endHuizhi = YES;
    }
    
    CLLocationCoordinate2D commonPolylineCoords[huizhiNum];
    for (int i=0; i<huizhiNum; i++) {
        NSDictionary * dic = self.pointArray[i];
        
        commonPolylineCoords[i].latitude=  [dic[@"latitude"] doubleValue];
        commonPolylineCoords[i].longitude=[dic[@"longitude"] doubleValue];
    }
    
    [self.mapViewhome removeOverlay:commonPolyline];
    //构造折线对象
    commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:huizhiNum];
    //在地图上添加折线对象
    [self.mapViewhome addOverlay: commonPolyline];
    
    //设置地图中心位置
    NSDictionary * huizhiDic2 = self.pointArray[huizhiNum];
    MAPointAnnotation * a1= [[MAPointAnnotation alloc] init];
    a1.coordinate = CLLocationCoordinate2DMake([huizhiDic2[@"latitude"] doubleValue], [ huizhiDic2[@"longitude"] doubleValue]);
    
    //划线 显示进行中的后3个点
    if (_TenPointArray.count<3) {
        [_TenPointArray addObject:a1];
    }else{
        [_TenPointArray replaceObjectAtIndex:0 withObject:a1];
    }
    
    
    //设置地图中心位置
    if(endHuizhi){
        [self.mapViewhome showOverlays:@[commonPolyline] edgePadding:UIEdgeInsetsMake(200, 100, 200, 100) animated:YES];
        huizhiNum = 0;
    }else{
        
        if (huizhiNum%9==0) {
            //            [self.mapViewhome showOverlays:@[commonPolyline] animated:YES];
            [self.mapViewhome showAnnotations:_TenPointArray edgePadding:UIEdgeInsetsMake(260, 150, 200, 100) animated:YES];
            
        }
        
    }
    
    
    
}
#pragma mark - MAMapViewDelegate 样式
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    
    
    //绘制线
    if ([overlay isKindOfClass:[MAPolyline class]])
        
    {
        if(huizhiNum<1500){
            
            [self performSelector:@selector(mapViewHUIZHI) withObject:nil afterDelay:huizhiTimes];
            
        }
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth= 3.f;
        
        polylineRenderer.strokeColor= [UIColor greenColor];
        
        polylineRenderer.lineJoinType = kMALineJoinRound;
        
        polylineRenderer.lineCapType= kMALineCapRound;
        
        return polylineRenderer;
        
    }
    
    return nil;
}


@end
