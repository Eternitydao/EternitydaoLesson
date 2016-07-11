//
//  HuanXinTabBar.h
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/4.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HuanXinTabBar;

@protocol HuanXinDelegate <NSObject>

- (void)HuanXinItemDidClicked:(HuanXinTabBar *)tabbar;

@end


@interface HuanXinTabBar : UITabBar

//当前选中的TabBar的下标
@property(nonatomic, assign)int currentSelected;
//当前选中的按钮
@property(nonatomic, strong)UIButton *currentSelectedItem;
//TabBar上面所有的item
@property(nonatomic, strong)NSArray *allItems;

@property(nonatomic, strong)id<HuanXinDelegate>huanxinDelegate;



//写一个初始化方法
- (id)initWithItems:(NSArray *)items frame:(CGRect)frame;


@end
