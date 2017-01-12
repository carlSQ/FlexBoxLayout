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

@interface CSSViewController ()

@end

@implementation CSSViewController


- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  UIView *root = [UIView new];
  [self.view addSubview:root];
  
  root.backgroundColor = [UIColor redColor];
  [root css_setFlexDirection:CSSFlexDirectionRow];

  [root css_setAlignItems:CSSAlignCenter];
  [root css_setJustifyContent:CSSJustifySpaceAround];
  
  UIView *child1 = [UIView new];
  child1.backgroundColor = [UIColor blueColor];
  
  [child1 css_setWidth:100];
  [child1 css_setHeight:100];
  UIView *child2 = [UIView new];
  child2.backgroundColor = [UIColor greenColor];
  [child2 css_setWidth:100];
  [child2 css_setHeight:100];
  
  
  UILabel *child3 = [UILabel new];
  child3.numberOfLines = 0;
  child3.backgroundColor = [UIColor yellowColor];
  [child3 css_wrapContent];
  [child3 setAttributedText:[[NSAttributedString alloc] initWithString:@"testfdsfdsfdsfdsfdsfdsafdsafdsafasdkkk" attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:18]}] ];
  
  [root addSubview:child1];
  [root addSubview:child2];
  [root addSubview:child3];
  
  
  CSSLayoutDiv *div1 = [CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionColumn
                                                 justifyContent:CSSJustifySpaceBetween
                                                     alignItems:CSSAlignCenter
                                                       children:@[child1, child2,child3]];
  
  
  [div1 css_setMargin:20 forEdge:CSSEdgeTop];
  
  [div1 css_setWidth:150];
  
  UIView *child5 = [UIView new];
  child5.backgroundColor = [UIColor blueColor];
  
  child5.CSSStyles = @{CSSWidthAttributeName:@(50),
                       CSSHeightAttributeName:@(50),
                       CSSMarginAttributeName:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)],
                       CSSFlexGrowAttributeName:@1.0};
  
  UIView *child6 = [UIView new];
  child6.backgroundColor = [UIColor greenColor];
  child6.CSSStyles = @{CSSWidthAttributeName:@(50),
                       CSSHeightAttributeName:@(100),
                       CSSMarginAttributeName:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)],
                       CSSFlexGrowAttributeName:@2.0};
  
  [child6 css_setMargin:10 forEdge:CSSEdgeAll];
  UIView *child7 = [UIView new];
  child7.backgroundColor = [UIColor yellowColor];
  child7.CSSStyles = @{CSSWidthAttributeName:@(50),
                       CSSHeightAttributeName:@(50),
                       CSSMarginAttributeName:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)],
                       CSSFlexGrowAttributeName:@1.0};
  
  UIView *child8 = [UIView new];
  child8.backgroundColor = [UIColor blackColor];
  
  child8.CSSStyles = @{CSSWidthAttributeName:@(50),
                       CSSHeightAttributeName:@(50),
                       CSSFlexGrowAttributeName:@1.0};
  
  [root addSubview:child5];
  [root addSubview:child6];
  [root addSubview:child7];
  [root addSubview:child8];
  
  CSSLayoutDiv *div2 =[CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionColumn
                                                justifyContent:CSSJustifySpaceAround
                                                    alignItems:CSSAlignCenter
                                                      children:@[child5,child6,child7,child8]];
  [div2 css_setWidth:150];
  [div2 css_setMargin:20 forEdge:CSSEdgeTop];
  root.css_children = @[div1,div2];

  [root css_asyApplyLayoutWithSize:css_undefinedSize];
  
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
