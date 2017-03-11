//
//  FBViewController.m
//  FBLayout
//
//  Created by qiang.shen on 01/03/2017.
//  Copyright (c) 2017 qiang.shen. All rights reserved.
//

#import "FBViewController.h"

#import "FlexBoxLayout.h"
#import "FBAsyLayoutTransaction.h"

@interface FBViewController ()

@end

@implementation FBViewController


- (void)viewDidLoad {
  
  [super viewDidLoad];
  

  UIScrollView *contentView = [UIScrollView new];
  contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44);
  [self.view addSubview:contentView];
  
  
  UIView *child1 = [UIView new];
  child1.backgroundColor = [UIColor blueColor];
  
  [child1 fb_makeLayout:^(FBLayout *layout) {
    layout.width.height.equalTo(@100);
  }];
  
  UIView *child2 = [UIView new];
  child2.backgroundColor = [UIColor greenColor];
  [child2 fb_makeLayout:^(FBLayout *layout) {
    layout.equalTo(child1);
  }];
  
  
  UILabel *child3 = [UILabel new];
  child3.numberOfLines = 0;
  child3.backgroundColor = [UIColor yellowColor];
  [child3 fb_wrapContent];
  [child3 setAttributedText:[[NSAttributedString alloc] initWithString:@"testfdsfdsfdsfdsfdsfdsafdsafdsafasdkkk" attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:18]}] ];
  
  [contentView addSubview:child1];
  [contentView addSubview:child2];
  [contentView addSubview:child3];
  
  
  FBLayoutDiv *div1 = [FBLayoutDiv layoutDivWithFlexDirection:FBFlexDirectionColumn
                                               justifyContent:FBJustifySpaceBetween
                                                   alignItems:FBAlignCenter
                                                     children:@[child1, child2,child3]];
  
  
  
  [div1 fb_makeLayout:^(FBLayout *layout) {
    layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(20, 0, 0, 0));
    layout.width.equalTo(@(150));
  }];
  
  
  UIView *child5 = [UIView new];
  child5.backgroundColor = [UIColor blueColor];
  [child5 fb_makeLayout:^(FBLayout *layout) {
    layout.width.height.equalTo(@(50)).margin.equalToEdgeInsets(UIEdgeInsetsMake(0, 0, 10, 0)).flexGrow.equalTo(@1.0);
  }];
  
  UIView *child6 = [UIView new];
  child6.backgroundColor = [UIColor greenColor];
  [child6 fb_makeLayout:^(FBLayout *layout) {
    layout.equalTo(child5);
    layout.flexGrow.equalTo(@(2.0));
    layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(10, 10, 10, 10));
  }];

  
  UIView *child7 = [UIView new];
  child7.backgroundColor = [UIColor yellowColor];
  [child7 fb_makeLayout:^(FBLayout *layout) {
    layout.equalTo(child5);
  }];
  
  UIView *child8 = [UIView new];
  child8.backgroundColor = [UIColor blackColor];
  
  [child8 fb_makeLayout:^(FBLayout *layout) {
    layout.equalTo(child5);
  }];
  
  FBLayoutDiv *div2 =[FBLayoutDiv layoutDivWithFlexDirection:FBFlexDirectionColumn
                                              justifyContent:FBJustifySpaceAround
                                                  alignItems:FBAlignCenter
                                                    children:@[child5,child6,child7,child8]];
  [div2 fb_makeLayout:^(FBLayout *layout) {
    layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(20, 0, 0, 0));
    layout.width.equalTo(@(150));
  }];
  
  [contentView addSubview:child5];
  [contentView addSubview:child6];
  [contentView addSubview:child7];
  [contentView addSubview:child8];
  
  FBLayoutDiv *root = [FBLayoutDiv layoutDivWithFlexDirection:FBFlexDirectionRow
                                               justifyContent:FBJustifySpaceAround
                                                   alignItems:FBAlignCenter
                                                     children:@[div1,div2]];
  
  contentView.fb_contentDiv = root;
  
  [root fb_asyApplyLayoutWithSize:[UIScreen mainScreen].bounds.size];
  
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
