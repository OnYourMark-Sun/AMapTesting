//
//  ViewController.m
//  Map-wms-Draw
//
//  Created by 徐士友 on 2018/9/6.
//  Copyright © 2018年 xujiahui. All rights reserved.
//

#import "ViewController.h"
#import "myButton.h"
#import "DrawTheTrajectoryViewController.h"
#define viewF self.view.frame.size
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSArray * array = @[@"绘制动画轨迹"];
    
    for (int i=0; i<array.count; i++) {
        
        UIButton * bu = [myButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(90, 200, viewF.width-180, 50) title:array[i] colors:[UIColor blueColor] andBackground:[UIColor lightGrayColor] tag:i+100 andBlock:^(myButton *button) {
            
            switch (button.tag-100) {
                case 0:
                    [self.navigationController pushViewController:[[DrawTheTrajectoryViewController alloc]init] animated:YES];
                    
                    break;
                    
                default:
                    break;
            }
            
            
            
        }];
        bu.layer.cornerRadius = 10;
        [self.view addSubview:bu];
        
    }
    
    
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
