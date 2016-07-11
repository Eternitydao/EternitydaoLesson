//
//  FriendsViewController.m
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/4.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import "FriendsViewController.h"
#import "HuanXinModel.h"
#import "MessageViewController.h"
#import "FriendTableViewCell.h"
@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate,EMContactManagerDelegate>

@property(nonatomic, strong)NSMutableArray *friendsArray;

@property(nonatomic, strong)HuanXinModel *huanxinManager;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsArray=[NSMutableArray array];
    
    //tableView注册
    [_friendTableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:FriendTableViewCell_Identify];
    //添加好友代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    //获取单例
    self.huanxinManager = [HuanXinModel shareHuanXinManager];
    //获取好友列表
    self.friendsArray = [self.huanxinManager requestFriends];
    //刷新tableView
    [self.friendTableView reloadData];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"添加好友" style:UIBarButtonItemStyleDone target:self action:@selector(addRight:)];
}
//点击添加的方法
- (void)addRight:(UIBarButtonItem *)sender
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    
    
    UIAlertAction *cancelActon = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
   
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"<对方账号>";
        textField.textAlignment = NSTextAlignmentCenter;
    
    }];
    
    UIAlertAction * addAction = [UIAlertAction actionWithTitle:@"添加" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        NSString*name = alertController.textFields.lastObject.text;
        NSLog(@"=============================%@",name);
        [[HuanXinModel shareHuanXinManager] addFriendWithUsername:name];
    
    }];
    [alertController addAction:addAction];
    [alertController addAction:cancelActon];
    [self presentViewController:alertController animated:YES completion:nil];
    
 
}
#pragma mark- EMContactManagerDelegate
//用户接受好友请求的回调
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername{
    NSLog(@"%@,同意添加好友",aUsername);
    
    [_friendsArray removeAllObjects];
   _friendsArray = [[HuanXinModel shareHuanXinManager] requestFriends];
    [_friendTableView reloadData];
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@,同意了您的好友请求",aUsername] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alertC addAction:comfirmAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
  
}

//用户拒绝我的好友请求的回调
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername{
    NSLog(@"%@ ,拒绝好友请求",aUsername);
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@,拒绝了您的好友请求",aUsername] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * comfirmAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alertC addAction:comfirmAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
}


/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage{
    NSLog(@"%@,添加我为好友,提示信息是：%@",aUsername,aMessage);
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"好友请求" message:[NSString stringWithFormat:@"%@请求您为好友！",aUsername] preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction * acceptAction = [UIAlertAction actionWithTitle:@"同意" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        //    同意
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
        [_friendsArray removeAllObjects];
       _friendsArray = [_huanxinManager requestFriends];
        [_friendTableView reloadData];
        if (!error) {
            NSLog(@"发送同意成功");
        }
    }];
    
    UIAlertAction *declineAction = [UIAlertAction actionWithTitle:@"拒绝" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        //    拒绝
        
        EMError *error1 = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
        if (!error1) {
            NSLog(@"发送拒绝成功");
        }
    }];
    
    [alertController addAction:acceptAction];
    [alertController addAction:declineAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}



#pragma mark-   UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//好友个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsArray.count;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FriendTableViewCell_Identify];
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:FriendTableViewCell_Identify];
    }
    cell.friendNameLabel.text = _friendsArray[indexPath.row];
    return cell;
}
//tableview编辑样式
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


//tableview删除方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        NSString *string= _friendsArray[indexPath.row];
        
        [_friendsArray removeObject:string];
        
        [[HuanXinModel shareHuanXinManager] deleteFriendByUserName:string];
        
    }
 //刷新UI
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_friendTableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *userName = _friendsArray[indexPath.row];
    [self performSegueWithIdentifier:@"MessageVC" sender:userName];
    

}





















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MessageVC"]) {
        MessageViewController * vc = (MessageViewController*)segue.destinationViewController;
        vc.userName = sender;
    }
}


@end
