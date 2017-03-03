# FlexBoxLayout

[![CI Status](http://img.shields.io/travis/LPD-iOS/FlexBoxLayout.svg?style=flat)](https://travis-ci.org/carlSQ/FlexBoxLayout)
[![Version](https://img.shields.io/cocoapods/v/FlexBoxLayout.svg?style=flat)](http://cocoapods.org/pods/FlexBoxLayout)
[![License](https://img.shields.io/cocoapods/l/FlexBoxLayout.svg?style=flat)](http://cocoapods.org/pods/FlexBoxLayout)
[![Platform](https://img.shields.io/cocoapods/p/FlexBoxLayout.svg?style=flat)](http://cocoapods.org/pods/FlexBoxLayout)

## Introduce

* flexbox layout
* 链式调用，布局方便
* 虚拟视图Div
* TableView 支持自动高度、布局缓存，contentView缓存，和自动cache 失效机制
* ScrollView 支持自适应contentSize
* 异步计算布局


## Demo
![Demo Overview](https://github.com/LPD-iOS/FlexBoxLayout/blob/master/Example/Example/show.gif)

## Cell layout in Demo

```objc

- (void)layoutView {

  [self fb_makeLayout:^(FBLayout *layout) {
    layout.flexDirection.equalTo(@(FBFlexDirectionColumn)).margin.equalToEdgeInsets(UIEdgeInsetsMake(0, 15, 0, 15)).alignItems.equalTo(@(FBAlignFlexStart));
  }];

  [_titleLabel fb_makeLayout:^(FBLayout *layout) {
    layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(10, 0, 0, 0)).wrapContent();
  }] ;
  

  [_contentLabel fb_makeLayout:^(FBLayout *layout) {
    layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(10, 0, 0, 0)).wrapContent();
  }];

  [_contentImageView fb_makeLayout:^(FBLayout *layout) {
    layout.margin.equalToEdgeInsets(UIEdgeInsetsMake(10, 0, 0, 0)).wrapContent();
  }];

  [_usernameLabel fb_makeLayout:^(FBLayout *layout) {
    layout.wrapContent().flexGrow.equalTo(@(1.0));
  }];

  [_timeLabel fb_makeLayout:^(FBLayout *layout) {
    layout.wrapContent().flexGrow.equalTo(@(1.0));
  }];

  FBLayoutDiv *div = [FBLayoutDiv layoutDivWithFlexDirection:FBFlexDirectionRow ];

  [div fb_makeLayout:^(FBLayout *layout) {
  layout.flexDirection.equalTo(@(FBFlexDirectionRow)).justifyContent.equalTo(@(FBJustifySpaceBetween)).alignItems.equalTo(@(FBAlignFlexStart)).margin.equalToEdgeInsets(UIEdgeInsetsMake(10, 0, 0, 0));
  }];

  div.fb_children = @[_usernameLabel,_timeLabel];

  self.fb_children =@[_titleLabel,_contentLabel,_contentImageView,div];
}

```


## Example

To run the example project, clone the repo.


## Installation

FBLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FlexBoxLayout"
```

## Usage

These are some flexbox introduce [FlexBox(Chinese)](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html), [A Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) and [A Visual Guide to CSS3 Flexbox Properties](https://scotch.io/tutorials/a-visual-guide-to-css3-flexbox-properties)。


### UIView + FBLayout Usage

Here are some simple uses

```objc
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
  
  child5.CSSStyles = @{FBWidthAttributeName:@(50),
                       FBHeightAttributeName:@(50),
                       FBMarginAttributeName:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)],
                       FBFlexGrowAttributeName:@1.0};
  
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
  
```


### FBLayoutDiv

FBLayoutDiv is virtual view, split view to a different area, avoid too much view.

```objc

FBLayoutDiv *div1 = [FBLayoutDiv layoutDivWithFlexDirection:FBFlexDirectionColumn
                                               justifyContent:FBJustifySpaceBetween
                                                   alignItems:FBAlignCenter
                                                     children:@[child1, child2,child3]];
                                
FBLayoutDiv *div2 =[FBLayoutDiv layoutDivWithFlexDirection:FBFlexDirectionColumn
                                              justifyContent:FBJustifySpaceAround
                                                  alignItems:FBAlignCenter
                                                    children:@[child5,child6,child7,child8]];
root.fb_children = @[div1,div2];                                
                                                       
```


### UITableView+FBLayout

 UITableView+FBLayout is category of UITableView. It support auto cell height of FBLayout and easy use.
 
 ```objc

  [self.tableView fb_setCellContnetViewBlockForIndexPath:^UIView *(NSIndexPath *indexPath) {
    return [[FBFeedView alloc]initWithModel:weakSelf.sections[indexPath.section][indexPath.row]];
  }];
  
  ....
  
  - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView fb_heightForIndexPath:indexPath];
  }

  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView fb_cellForIndexPath:indexPath];
  }

```

### UIScrollView+FBLayout

It support auto content size

```objc
  FBLayoutDiv *root = [FBLayoutDiv layoutDivWithFlexDirection:FBFlexDirectionRow
                                                 justifyContent:FBJustifySpaceAround
                                                     alignItems:FBAlignCenter
                                                       children:@[div1,div2]];
  
  contentView.fb_contentDiv = root;
```

### Flexbox container properties

##### flex-direction

This property specifies how flex items are laid out in the flex container, by setting the direction of the flex container’s main axis. They can be laid out in two main directions, like rows horizontally or like columns vertically.

```objc
FBFlexDirectionRow;
```
![ROW](https://cask.scotch.io/2015/04/flexbox-flex-direction-row.jpg)

```objc
FBFlexDirectionRowReverse;
```
![RowReverse](https://cask.scotch.io/2015/04/flexbox-flex-direction-row-reverse.jpg)

```objc
FBFlexDirectionColumn;
```
![Colum](https://cask.scotch.io/2015/04/flexbox-flex-direction-column.jpg)

```objc
FBFlexDirectionColumnReverse;
```
![ColumReverse](https://cask.scotch.io/2015/04/flexbox-flex-direction-column-reverse.jpg)

##### flex-wrap

The initial flexbox concept is the container to set its items in one single line. The flex-wrap property controls if the flex container lay out its items in single or multiple lines, and the direction the new lines are stacked in.Supports only 'nowrap' (which is the default) or 'wrap'

```objc
FBWrapNoWrap;
```
![noWrap](https://cask.scotch.io/2015/04/flexbox-flex-wrap-nowrap.jpg)

```objc
FBWrapWrap;
```
![noWrap](https://cask.scotch.io/2015/04/flexbox-flex-wrap-wrap.jpg)

##### justify-content

The justify-content property aligns flex items along the main axis of the current line of the flex container. It helps distribute left free space when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size.

```objc
FBJustifyFlexStart;
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-flex-start.jpg)
```objc
FBJustifyCenter;
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-center.jpg)
```objc
FBJustifyFlexEnd
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-flex-end.jpg)
```objc
FBJustifySpaceBetween;
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-space-between.jpg)
```objc
FBJustifySpaceAround;
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-space-around.jpg)

##### align-items

Flex items can be aligned in the cross axis of the current line of the flex container, similar to justify-content but in the perpendicular direction. This property sets the default alignment for all flex items, including the anonymous ones.

```objc
FBAlignFlexStart;
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-items-flex-start.jpg)

```objc
FBAlignCenter;
```
![CSSAlignCenter](https://cask.scotch.io/2015/04/flexbox-align-items-center.jpg)

```objc
FBAlignFlexEnd;
```
![CSSAlignFlexEnd](https://cask.scotch.io/2015/04/flexbox-align-items-flex-end.jpg)

```objc
FBAlignStretch;
```
![CSSAlignStretch](https://cask.scotch.io/2015/04/flexbox-align-items-stretch.jpg)

##### align-content

The align-content property aligns a flex container’s lines within the flex container when there is extra space in the cross-axis, similar to how justify-content aligns individual items within the main-axis.

```objc
FBAlignFlexStart;
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-flex-start.jpg)


```objc
FBAlignCenter;
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-center.jpg)


```objc
FBAlignFlexEnd;
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-flex-end.jpg)


```objc
FBAlignStretch;
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-stretch.jpg)

### Flexbox item properties

##### flex-grow

This property specifies the flex grow factor, which determines how much the flex item will grow relative to the rest of the flex items in the flex container when positive free space is distributed.

```objc
FlexGrow;
```
![FlexGrow-1.0](https://cask.scotch.io/2015/04/flexbox-flex-grow-1.jpg)
![FlexGrow-3.0](https://cask.scotch.io/2015/04/flexbox-flex-grow-2.jpg)

##### flex-shrink

The flex-shrink specifies the flex shrink factor, which determines how much the flex item will shrink relative to the rest of the flex items in the flex container when negative free space is distributed.

By default all flex items can be shrunk, but if we set it to 0 (don’t shrink) they will maintain the original size
```objc
FlexShrink;
```
![flex-shrink](https://cask.scotch.io/2015/04/flexbox-flex-shrink.jpg)

##### flex-basis

This property takes the same values as the width and height properties, and specifies the initial main size of the flex item, before free space is distributed according to the flex factors.

```objc
FlexBasis:350;
```
![flex-basis](https://cask.scotch.io/2015/04/flexbox-flex-basis.jpg)

##### align-self
This align-self property allows the default alignment (or the one specified by align-items) to be overridden for individual flex items. Refer to align-items explanation for flex container to understand the available values.

```objc
FBAlignFlexStart;
```
![align-self](https://cask.scotch.io/2015/04/flexbox-align-self.jpg)


## Author

qiang.shen

## License

FBLayout is available under the MIT license. See the LICENSE file for more info.




