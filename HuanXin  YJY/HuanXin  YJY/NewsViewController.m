//
//  NewsViewController.m
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/4.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import "NewsViewController.h"

#import "MessageViewController.h"

@interface NewsViewController ()<EMChatManagerDelegate,UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)NSMutableArray * newsArray;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会话";
    _newsArray = [NSMutableArray array];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];

NSArray *conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    _newsArray = conversations.mutableCopy;
    NSLog(@"conversations=====%@",conversations);
}



#pragma mark-  UITableViewDataSource,UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reuse"];
    }
    cell.textLabel.text = @"会话";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.hidesBottomBarWhenPushed=YES;
    UIStoryboard * SB = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MessageViewController * vc = [SB instantiateViewControllerWithIdentifier:@"MessageViewController"];

    [self.navigationController pushViewController:vc animated:YES];
//     self.hidesBottomBarWhenPushed=NO;
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
