//
//  MineMessageTableViewCell.h
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/5.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MineMessageTableViewCell_Identify @"MineMessageTableViewCell_Identify"
@interface MineMessageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *otherAvatar;
@property (strong, nonatomic) IBOutlet UILabel *myMessageLabel;

@end
