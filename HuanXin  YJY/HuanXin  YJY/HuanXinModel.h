//
//  HuanXinModel.h
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/4.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuanXinModel : NSObject

@property(nonatomic,strong)NSString * passValue;
+ (HuanXinModel*)shareHuanXinManager;


//获取好友的方法
- (NSMutableArray *)requestFriends;
#pragma mark- 添加好友
- (void)addFriendWithUsername:(NSString *)username;

#pragma mark- 删除好友
-(void)deleteFriendByUserName:(NSString*)userName;

#pragma mark-  把好友添加至黑名单
- (void)addFriendToBlackList:(NSString*)userName;

#pragma mark-  移除黑名单
- (void)removeBlackListByUserName:(NSString*)userName;
@end
