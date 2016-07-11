//
//  RootViewController.m
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/4.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import "RootViewController.h"
#import "NewsViewController.h"
#import "FriendsViewController.h"
#import "LoginViewController.h"


@interface RootViewController ()<HuanXinDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏系统自带的Tabbar
    self.tabBar.hidden = YES;
    UIButton *button1=[self ButtonWithTitle:@"消息" image1:@"paperH.png" image2:@"paper.png"];
    UIButton *button2=[self ButtonWithTitle:@"好友" image1:@"2imageH.png" image2:@"2image.png"];
    UIButton *button3=[self ButtonWithTitle:@"个人" image1:@"personH.png" image2:@"person.png"];
    
    NSArray *array=@[button1,button2,button3];
    self.DBtabbar = [[HuanXinTabBar alloc]initWithItems:array frame:CGRectMake(0, self.view.frame.size.height-49, 414, 49)];
    self.DBtabbar.currentSelectedItem = button1;
    self.DBtabbar.currentSelectedItem.selected = YES;
    [self.view addSubview:self.DBtabbar];
    
    self.DBtabbar.huanxinDelegate = self;
}
//创建Button的方法
- (UIButton *)ButtonWithTitle:(NSString *)title image1:(NSString *)image1 image2:(NSString *)image2
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image2] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return button;
}
//实现自己写的代理方法
- (void)HuanXinItemDidClicked:(HuanXinTabBar *)tabbar
{
    
    self.selectedIndex = tabbar.currentSelected;
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
