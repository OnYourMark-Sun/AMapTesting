//
//  WMS_testViewController.m
//  Map-wms-Draw
//
//  Created by 徐士友 on 2018/9/7.
//  Copyright © 2018年 xujiahui. All rights reserved.
//

#import "WMS_testViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "WMSTileOverlayUtil.h"
#import "aesTools.h"
#define WeakSelf  __weak typeof(self) weakSelf = self


@interface WMS_testViewController ()<MAMapViewDelegate>
{
    NSString * string2;
}
@property(nonatomic,strong)MAMapView *mapView;
@property (nonatomic, strong) MATileOverlay * polygonsJFQ;//矩形数组

@end

@implementation WMS_testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //////////        没有密💊 请自行找数据     ///////////////
    // 解析plist 获取Url
    NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"urldata" ofType:@"plist"]];
    //获取data 进行解密
    string2 = [aesTools AESToString:dataDict[@"URLWMS"]];
    ////////////////////////////////////////////////////////////////
    
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"WMS" style:UIBarButtonItemStylePlain target:self action:@selector(wmsAction)];
    
    //   加载地图
    [self setMap];
    
    //加载wms
    [self loadData];

}

-(void)wmsAction{
    //添加wms视图
    [self.mapView addOverlay:_polygonsJFQ];
    //前往天安门
    self.mapView.centerCoordinate =  CLLocationCoordinate2DMake(39.908692, 116.397477);
    //保持比例
     [self.mapView setZoomLevel:12 animated:YES];
    
}
-(void)loadData{
    
    //根据接口进行绘制
    _polygonsJFQ =[[WMSTileOverlayUtil
                    alloc] initWithRootURL:string2];
}
#pragma mark Map
-(void)setMap{
    
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    self.mapView.showsCompass= NO; // 设置成NO表示关闭指南针；YES表示显示指南针
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = NO;
    [self.mapView setZoomLevel:12 animated:YES];
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.delegate =self;
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    ///把地图添加至view
    
    self.mapView.mapType = MAMapTypeNavi;
    [self.view addSubview:self.mapView];
    
    
}

#pragma mark - MAMapViewDelegate 样式
-(MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    ///绘图瓦块
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        MATileOverlayRenderer *renderer = [[MATileOverlayRenderer alloc] initWithTileOverlay:overlay];
        return renderer;
    }
    
    return nil;
}

    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
