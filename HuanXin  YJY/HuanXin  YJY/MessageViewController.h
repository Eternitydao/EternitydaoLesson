//
//  MessageViewController.h
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/6.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) IBOutlet UITextView *messageTextFiled;



/** 图片 */
@property(nonatomic,copy)UIImage* image;


/** 图片选择器 */
@property(nonatomic,strong)UIImagePickerController* imagePController;


/** 属性 传值 */
@property(nonatomic,copy)NSString* userName;
@end
