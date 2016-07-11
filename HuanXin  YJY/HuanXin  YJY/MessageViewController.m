//
//  NewsViewController.m
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/4.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import "MessageViewController.h"
#import "HuanXinModel.h"
#import "MineMessageTableViewCell.h"
#import "OtherMessageTableViewCell.h"

#import "MineImageTableViewCell.h"
#import "OtherImageTableViewCell.h"
@interface MessageViewController ()
<   EMChatManagerDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>

@property(nonatomic,assign)BOOL flag;
@property(nonatomic,strong)NSMutableArray * messageArray;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _flag = YES;
    self.title = _userName;
    _messageArray = [NSMutableArray array];
    //    创建一个会话
    
 EMConversation* conversion = [[EMClient sharedClient].chatManager getConversation:_userName type:EMConversationTypeChat createIfNotExist:YES];
   
#warning
//    获取聊天消息
    _messageArray = [conversion loadMoreMessagesContain:nil before:-1 limit:20 from:nil direction:(EMMessageSearchDirectionUp)].mutableCopy;
     [_messageTableView reloadData];
    
#warning
    //    注册cell
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_messageTableView registerNib:[UINib nibWithNibName:@"MineMessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MineMessageTableViewCell_Identify];
    
    [_messageTableView registerNib:[UINib nibWithNibName:@"OtherMessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:OtherMessageTableViewCell_Identify];
    
     [_messageTableView registerNib:[UINib nibWithNibName:@"OtherImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:OtherImageTableViewCell_Identify];
     [_messageTableView registerNib:[UINib nibWithNibName:@"MineImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MineImageTableViewCell_Identify];

   
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [self scrollviewToBottom];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
}
/*!
 *  从数据库获取指定类型的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息向前取，如果 aLimit 是负数，则获取所有符合条件的消息
 *
 *  @param aType        消息类型
 *  @param aTimestamp   参考时间戳
 *  @param aLimit       获取的条数
 *  @param aSender      消息发送方，如果为空则忽略
 *  @param aDirection   消息搜索方向
 *
 *  @result 消息列表<EMMessage>
 */
- (IBAction)readImage:(UIButton *)sender {
    _imagePController = [[UIImagePickerController alloc]init];
    _imagePController.delegate = self;

    [self presentViewController:_imagePController animated:YES completion:^{
        
    }];
    
    
    
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    取得图片
    UIImage * selectImage = info[UIImagePickerControllerOriginalImage];
  
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    NSLog(@"==============%@",selectImage);
     _image = selectImage;
    

}
//发送文本消息
- (IBAction)sendMessage:(UIButton *)sender {
    if (_messageTextFiled.text.length == 0) {
        _flag = NO;
//        UIImage * image = _imageV.image;
        NSData * data = UIImageJPEGRepresentation(_image, 1);
//        NSLog(@"dada========%@",data);
        
        EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:data displayName:@"image.png"];
        NSString *from = [[EMClient sharedClient] currentUsername];
        
        //生成Message
        EMMessage *message = [[EMMessage alloc] initWithConversationID:_userName from:from to:_userName body:body ext:nil];
        message.chatType = EMChatTypeChat;// 设置为单聊消息
        [self mysendMessage:message];
    }else{
        _flag = YES;
            //    构造文字消息
            EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:_messageTextFiled.text];
            NSString *from = [[EMClient sharedClient] currentUsername];
        
            //生成Message
            EMMessage *message = [[EMMessage alloc] initWithConversationID:_userName from:from to:_userName body:body ext:nil];
            NSLog(@"_userName========%@",_userName);
            message.chatType = EMChatTypeChat;// 设置为单聊消息
            //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
            //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
        [self mysendMessage:message];
    }
    


    
    
 
}
- (void)mysendMessage:(EMMessage*)aMessage{
    [[EMClient sharedClient].chatManager asyncSendMessage:aMessage progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        NSLog(@"====发送消息成功");
        //将自己发送的消息放入数组
        [_messageArray addObject:aMessage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_messageTableView reloadData];
            [self scrollviewToBottom];
        });
        
    }];
}

#pragma mark-  收到的消息
- (void)didReceiveMessages:(NSArray *)aMessages{
    
    for (EMMessage *message in aMessages) {
        //       将收到的消息存入数组
        if ([message.conversationId isEqualToString:_userName]) {
              [_messageArray addObject:message];
        }
      
  
    }
     [_messageTableView reloadData];
     [self scrollviewToBottom];
}



#pragma mark-  UITableViewDataSource,UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messageArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   EMMessage * message = _messageArray[indexPath.row];
    
    if ([message.from isEqualToString:[HuanXinModel shareHuanXinManager].passValue]) {
        
        if (message.body.type == EMMessageBodyTypeText) {
            MineMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MineMessageTableViewCell_Identify];
            
            if (cell == nil) {
                
                cell = [[MineMessageTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:MineMessageTableViewCell_Identify];
            }
        
            
            EMTextMessageBody* textBody = (EMTextMessageBody*)message.body;
            
            cell.myMessageLabel.text = textBody.text;
            
            
            
            return cell;
        }
    MineImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MineMessageTableViewCell_Identify];
        
    if (cell == nil) {
            
        cell = [[MineImageTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:MineImageTableViewCell_Identify];
    }
        
        
        EMImageMessageBody* imageBody = (EMImageMessageBody*)message.body;
          cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageBody.remotePath]]];
        
        
        
        return cell;
    
    }
    
// Other
    if (message.body.type == EMMessageBodyTypeText) {
        OtherMessageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:OtherMessageTableViewCell_Identify];
        if (cell == nil) {
            cell = [[OtherMessageTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:OtherMessageTableViewCell_Identify];
        }
          
        
        EMTextMessageBody* textBody = (EMTextMessageBody*)message.body;
        
        cell.messageLabel.text = textBody.text;
        return cell;
        }
        OtherImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:OtherImageTableViewCell_Identify];
    
            if (cell == nil) {
        
            cell = [[OtherImageTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:OtherImageTableViewCell_Identify];
            }
    
    
            EMImageMessageBody* imageBody = (EMImageMessageBody*)message.body;
            cell.otherImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageBody.remotePath]]];
    
            return cell;
    
 
}
- (void)scrollviewToBottom{
    if (_messageArray.count < 1) {
        return;
    }
//    获取tableview的最后一个cell的IndexPath
    NSIndexPath * path = [NSIndexPath indexPathForItem:_messageArray.count-1 inSection:0];
//    tableview滑动到最后一个cell的底部
    [_messageTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end