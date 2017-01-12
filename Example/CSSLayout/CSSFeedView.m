//
//  CSSFeedView.m
//  CSSLayout
//
//  Created by 沈强 on 2017/1/11.
//  Copyright © 2017年 qiang.shen. All rights reserved.
//

#import "CSSFeedView.h"
#import "UIView+CSSLayout.h"
#import "CSSLayoutDiv.h"

@interface CSSFeedView ()

@property (nonatomic, strong)  UILabel *titleLabel;
@property (nonatomic, strong)  UILabel *contentLabel;
@property (nonatomic, strong)  UIImageView *contentImageView;
@property (nonatomic, strong)  UILabel *usernameLabel;
@property (nonatomic, strong)  UILabel *timeLabel;

@end


@implementation CSSFeedView

- (instancetype)initWithModel:(CSSFeedModel *)model {
  if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)]) {
    [self configView];
    [self configData:model];
    [self layoutView];
  }
  
  return self;
}

- (void)configView {
  
  _titleLabel = [UILabel new];
  [self addSubview:_titleLabel];
  
  _contentLabel = [UILabel new];
  [self addSubview:_contentLabel];
  _contentLabel.numberOfLines = 0;
  
  _contentImageView = [UIImageView new];
  _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
  [self addSubview:_contentImageView];
  
  _usernameLabel = [UILabel new];
  [self addSubview:_usernameLabel];
  
  _timeLabel = [UILabel new];
  [self addSubview:_timeLabel];
}

- (void)configData:(CSSFeedModel *)model {
  
  _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
  
  _contentLabel.attributedText = [[NSAttributedString alloc] initWithString:model.content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
  
  _contentImageView.image = [UIImage imageNamed:model.imageName];
  
  _usernameLabel.attributedText = [[NSAttributedString alloc] initWithString:model.username attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
  
  _timeLabel.attributedText = [[NSAttributedString alloc] initWithString:model.time attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
  
}

- (void)layoutView {
  
  [self css_setFlexDirection:CSSFlexDirectionColumn];
  
  [self css_setMargin:15 forEdge:CSSEdgeHorizontal];
  
  [self css_setAlignItems:CSSAlignFlexStart];
  
  [_titleLabel css_setMargin:10 forEdge:CSSEdgeTop];
  
  [_titleLabel css_wrapContent];
  
  [_contentLabel css_setMargin:10 forEdge:CSSEdgeTop];
  [_contentLabel css_wrapContent];
  
  [_contentImageView css_setMargin:10 forEdge:CSSEdgeTop];
  [_contentImageView css_wrapContent];
  

  [_usernameLabel css_wrapContent];
  
  [_timeLabel css_wrapContent];
  
  CSSLayoutDiv *usernameDiv = [CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionRow justifyContent:CSSJustifyFlexStart alignItems:CSSAlignFlexStart children:@[_usernameLabel]];
  [usernameDiv css_setFlexGrow:1.0];
  
  CSSLayoutDiv *timeDiv = [CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionRow justifyContent:CSSJustifyFlexEnd alignItems:CSSAlignFlexEnd children:@[_timeLabel]];
   [timeDiv css_setFlexGrow:1.0];
  
  CSSLayoutDiv *div = [CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionRow justifyContent:CSSJustifySpaceBetween alignItems:CSSAlignFlexStart children:@[usernameDiv,timeDiv]];

  [div css_setMargin:10 forEdge:CSSEdgeTop];
  
  self.css_children =@[_titleLabel,_contentLabel,_contentImageView,div];
}

@end
