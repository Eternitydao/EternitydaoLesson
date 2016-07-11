//
//  OtherMessageTableViewCell.h
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/5.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define OtherMessageTableViewCell_Identify @"OtherMessageTableViewCell_Identify"
@interface OtherMessageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIImageView *otherAvatar;

@end
