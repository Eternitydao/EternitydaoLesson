//
//  LoginViewController.m
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/4.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import "LoginViewController.h"
#import "EMSDK.h"
#import "HuanXinModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//点击登录
- (IBAction)LoginButton:(UIButton *)sender
{
    EMError *error = [[EMClient sharedClient] loginWithUsername:_userNameTextField.text     password:_passWordTextField.text];
    if (!error)
    {
        //这是自动登录的设置
        //[[EMClient sharedClient].options setIsAutoLogin:YES];
        NSLog(@"登录成功");
//
        [HuanXinModel shareHuanXinManager].passValue = _userNameTextField.text;
        //页面跳转方法
        self.tabBarController.selectedIndex = 1;
       
    }else {
        
        NSLog(@"error = %u",error.code);
    }
}
//点击注册
- (IBAction)RegisterButton:(id)sender
{
    //跳转到注册页面
    [self performSegueWithIdentifier:@"register" sender:nil];
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
