//
//  HuanXinTabBar.m
//  HuanXin  YJY
//
//  Created by lanou3g on 16/7/4.
//  Copyright © 2016年 yangjingyi. All rights reserved.
//

#import "HuanXinTabBar.h"


@implementation HuanXinTabBar

//写一个初始化方法
- (id)initWithItems:(NSArray *)items frame:(CGRect)frame
{
    if (self = [super init]) {
        self.frame = frame;
        for (int i=0; i<items.count; i++) {
            UIButton *button = (UIButton *)items[i];
            CGFloat width = self.bounds.size.width / items.count;
            CGFloat height = self.bounds.size.height;
            button.frame = CGRectMake( i*width, 0, width, height);
            //给按钮添加点击方法
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:button];
        }
        self.currentSelected = 2;
        self.currentSelectedItem = items[2];
        self.allItems = items;
    }
    return self;
}
//点击按钮的方法
- (void)buttonClicked:(UIButton *)button
{
    self.currentSelectedItem = button;
    for (int i=0; i<self.allItems.count; i++) {
        UIButton *btn=(UIButton *)self.allItems[i];
        if (btn == button) {
            self.currentSelected = i;
            button.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    if (_huanxinDelegate) {
        [_huanxinDelegate HuanXinItemDidClicked:self];
    }
}



@end
