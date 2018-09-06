//
//  myButton.h
//  02-button的封装-block
//
//  Created by AirspaceProjecton 16/6/16.
//  Copyright © 2016年 AirspaceProject All rights reserved.
//

#import <UIKit/UIKit.h>

@class myButton;
@protocol myButtonDelegate <NSObject>
//在写协议方法的时候，最好将自身作为参数传出
-(void)myButtonClicked:(myButton *)myButton;

@end

//起别名  声明的是一个block类型
typedef void (^myButtonBlock) (myButton *button);

@interface myButton : UIButton


+(myButton *)buttonWithType:(UIButtonType )type frame:(CGRect )frame title:(NSString *)title tag:(NSInteger)tag andDelegate:(id)delegate;

+(myButton *)buttonWithType:(UIButtonType )type frame:(CGRect )frame title:(NSString *)title colors:(UIColor*)color  andBackground:(UIColor *)backgroundColor tag:(NSInteger)tag andBlock:(myButtonBlock)block;

+(myButton *)buttonWithType:(UIButtonType )type frame:(CGRect )frame title:(NSString *)title titleColor:(UIColor*)color andBackground:(UIColor *)backgroundColor cornerRadius:(CGFloat)corner tag:(NSInteger)tag andBlock:(myButtonBlock)block;

+(myButton *)buttonWithType:(UIButtonType )type frame:(CGRect )frame tag:(NSInteger)tag image:(NSString *)image andBlock:(myButtonBlock)block;
@end


