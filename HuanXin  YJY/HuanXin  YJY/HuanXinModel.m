//
//  HuanXinModel.m
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/4.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import "HuanXinModel.h"
#import "EMSDK.h"
@implementation HuanXinModel

+(HuanXinModel *)shareHuanXinManager{
    static HuanXinModel* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HuanXinModel alloc]init];
    });
    return manager;
}

//获取好友的方法
- (NSMutableArray *)requestFriends
{
    NSMutableArray *array=[NSMutableArray array];
    EMError *error = nil;
    //从数据库获取所有好友的方法
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        NSLog(@"获取成功 -- %@",userlist);
        for (NSString *userName in userlist) {
            [array addObject:userName];
        }
    }
    return array;
}
#pragma mark- 添加好友

- (void)addFriendWithUsername:(NSString *)username
{
    EMError *error = [[EMClient sharedClient].contactManager addContact:username message:[NSString stringWithFormat:@"%@,@我想加您为好友",username]];
    if (!error) {
        NSLog(@"申请添加好友成功");
    }
}

#pragma mark- 删除好友
-(void)deleteFriendByUserName:(NSString*)userName{
    // 删除好友
    EMError *error = [[EMClient sharedClient].contactManager deleteContact:userName];
    if (!error) {
        NSLog(@"删除成功");
    }
    [self requestFriends];
}


#pragma mark-  把好友添加至黑名单
- (void)addFriendToBlackList:(NSString*)userName{
    //    EMError *error = nil;
    //	将6001加入黑名单
    EMError * error = [[EMClient sharedClient].contactManager addUserToBlackList:userName relationshipBoth:YES];
    if (!error) {
        NSLog(@"发送成功");
    }
    [self requestFriends];
}

#pragma mark-  移除黑名单
- (void)removeBlackListByUserName:(NSString*)userName{
    // 将6001移除黑名单
    EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:userName];
    if (!error) {
        NSLog(@"发送成功");
    }
    [self requestFriends];
}














@end
