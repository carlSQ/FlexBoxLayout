//
//  CSSViewController.m
//  CSSLayout
//
//  Created by qiang.shen on 01/03/2017.
//  Copyright (c) 2017 qiang.shen. All rights reserved.
//

#import "CSSViewController.h"
#import "UIView+CSSLayout.h"
#import "CSSLayoutDiv.h"
#import "UIScrollView+CSSLayout.h"

@interface CSSViewController ()

@end

@implementation CSSViewController


- (void)viewDidLoad {
  
  [super viewDidLoad];
  

  UIScrollView *contentView = [UIScrollView new];
  contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44);
  [self.view addSubview:contentView];
  
  
  UIView *child1 = [UIView new];
  child1.backgroundColor = [UIColor blueColor];
  
  [child1 css_makeLayout:^(CSSLayout *layout) {
    layout.width.height.equalTo(@100);
  }];
  
  UIView *child2 = [UIView new];
  child2.backgroundColor = [UIColor greenColor];
  [child2 css_makeLayout:^(CSSLayout *layout) {
    layout.equalTo(child1);
  }];
  
  
  UILabel *child3 = [UILabel new];
  child3.numberOfLines = 0;
  child3.backgroundColor = [UIColor yellowColor];
  [child3 css_wrapContent];
  [child3 setAttributedText:[[NSAttributedString alloc] initWithString:@"testfdsfdsfdsfdsfdsfdsafdsafdsafasdkkk" attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:18]}] ];
  
  [contentView addSubview:child1];
  [contentView addSubview:child2];
  [contentView addSubview:child3];
  
  
  CSSLayoutDiv *div1 = [CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionColumn
                                                 justifyContent:CSSJustifySpaceBetween
                                                     alignItems:CSSAlignCenter
                                                       children:@[child1, child2,child3]];
  
  
  
  [div1 css_makeLayout:^(CSSLayout *layout) {
    layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(20, 0, 0, 0));
    layout.width.equalTo(@(150));
  }];
  
  
  UIView *child5 = [UIView new];
  child5.backgroundColor = [UIColor blueColor];
  
  child5.CSSStyles = @{CSSWidthAttributeName:@(50),
                       CSSHeightAttributeName:@(50),
                       CSSMarginAttributeName:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)],
                       CSSFlexGrowAttributeName:@1.0};
  
  UIView *child6 = [UIView new];
  child6.backgroundColor = [UIColor greenColor];
  [child6 css_makeLayout:^(CSSLayout *layout) {
    layout.equalTo(child5);
    layout.flexGrow.equalTo(@(2.0));
     layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(10, 10, 10, 10));
  }];

  
  UIView *child7 = [UIView new];
  child7.backgroundColor = [UIColor yellowColor];
  [child7 css_makeLayout:^(CSSLayout *layout) {
    layout.equalTo(child5);
  }];
  
  UIView *child8 = [UIView new];
  child8.backgroundColor = [UIColor blackColor];
  
  [child8 css_makeLayout:^(CSSLayout *layout) {
    layout.equalTo(child5);
  }];
  
  CSSLayoutDiv *div2 =[CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionColumn
                                                justifyContent:CSSJustifySpaceAround
                                                    alignItems:CSSAlignCenter
                                                      children:@[child5,child6,child7,child8]];
  [div2 css_makeLayout:^(CSSLayout *layout) {
    layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(20, 0, 0, 0));
    layout.width.equalTo(@(150));
  }];
  
  [contentView addSubview:child5];
  [contentView addSubview:child6];
  [contentView addSubview:child7];
  [contentView addSubview:child8];
  
  CSSLayoutDiv *root = [CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionRow
                                                 justifyContent:CSSJustifySpaceAround
                                                     alignItems:CSSAlignCenter
                                                       children:@[div1,div2]];
  
  contentView.css_contentDiv = root;
  [root css_asyApplyLayoutWithSize:[UIScreen mainScreen].bounds.size];
  
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
