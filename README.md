# CSSLayout

[![CI Status](http://img.shields.io/travis/carlSQ/CSSLayout.svg?style=flat)](https://travis-ci.org/carlSQ/CSSLayout)
[![Version](https://img.shields.io/cocoapods/v/FlexBoxLayout.svg?style=flat)](http://cocoapods.org/pods/FlexBoxLayout)
[![License](https://img.shields.io/cocoapods/l/FlexBoxLayout.svg?style=flat)](http://cocoapods.org/pods/FlexBoxLayout)
[![Platform](https://img.shields.io/cocoapods/p/FlexBoxLayout.svg?style=flat)](http://cocoapods.org/pods/FlexBoxLayout)

## Overview
![Demo Overview](https://github.com/carlSQ/CSSLayout/blob/master/Example/CSSLayout/show.gif)

## Example

To run the example project, clone the repo.


## Installation

CSSLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FlexBoxLayout"
```

## Usage

These are some flexbox introduce [FlexBox(Chinese)](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html), [A Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) and [A Visual Guide to CSS3 Flexbox Properties](https://scotch.io/tutorials/a-visual-guide-to-css3-flexbox-properties)。

### Flexbox container properties

##### flex-direction

This property specifies how flex items are laid out in the flex container, by setting the direction of the flex container’s main axis. They can be laid out in two main directions, like rows horizontally or like columns vertically.

```objc
 CSSFlexDirectionRow;
```
![ROW](https://cask.scotch.io/2015/04/flexbox-flex-direction-row.jpg)

```objc
 CSSFlexDirectionRowReverse;
```
![RowReverse](https://cask.scotch.io/2015/04/flexbox-flex-direction-row-reverse.jpg)

```objc
 CSSFlexDirectionColumn;
```
![Colum](https://cask.scotch.io/2015/04/flexbox-flex-direction-column.jpg)

```objc
 CSSFlexDirectionColumnReverse;
```
![ColumReverse](https://cask.scotch.io/2015/04/flexbox-flex-direction-column-reverse.jpg)

##### flex-wrap

The initial flexbox concept is the container to set its items in one single line. The flex-wrap property controls if the flex container lay out its items in single or multiple lines, and the direction the new lines are stacked in.Supports only 'nowrap' (which is the default) or 'wrap'

```objc
 CSSWrapNoWrap;
```
![noWrap](https://cask.scotch.io/2015/04/flexbox-flex-wrap-nowrap.jpg)

```objc
 CSSWrapWrap;
```
![noWrap](https://cask.scotch.io/2015/04/flexbox-flex-wrap-wrap.jpg)

##### justify-content

The justify-content property aligns flex items along the main axis of the current line of the flex container. It helps distribute left free space when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size.

```objc
 CSSJustifyFlexStart;
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-flex-start.jpg)
```objc
 CSSJustifyCenter;
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-center.jpg)
```objc
 CSSJustifyFlexEnd
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-flex-end.jpg)
```objc
 CSSJustifySpaceBetween;
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-space-between.jpg)
```objc
 CSSJustifySpaceAround;
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-space-around.jpg)

##### align-items

Flex items can be aligned in the cross axis of the current line of the flex container, similar to justify-content but in the perpendicular direction. This property sets the default alignment for all flex items, including the anonymous ones.

```objc
 CSSAlignFlexStart;
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-items-flex-start.jpg)

```objc
 CSSAlignCenter;
```
![CSSAlignCenter](https://cask.scotch.io/2015/04/flexbox-align-items-center.jpg)

```objc
 CSSAlignFlexEnd;
```
![CSSAlignFlexEnd](https://cask.scotch.io/2015/04/flexbox-align-items-flex-end.jpg)

```objc
 CSSAlignStretch;
```
![CSSAlignStretch](https://cask.scotch.io/2015/04/flexbox-align-items-stretch.jpg)

##### align-content

The align-content property aligns a flex container’s lines within the flex container when there is extra space in the cross-axis, similar to how justify-content aligns individual items within the main-axis.

```objc
 CSSAlignFlexStart;
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-flex-start.jpg)


```objc
 CSSAlignCenter;
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-center.jpg)


```objc
 CSSAlignFlexEnd;
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-flex-end.jpg)


```objc
 CSSAlignStretch;
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
CSSAlignFlexStart;
```
![align-self](https://cask.scotch.io/2015/04/flexbox-align-self.jpg)

### UIView + CSSLayout Usage

```objc
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
  
```


### CSSLayoutDiv

CSSLayoutDiv is virtual view, split view to a different area, avoid too much view.

```objc

CSSLayoutDiv *div1 = [CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionColumn
                                               justifyContent:CSSJustifySpaceBetween
                                                   alignItems:CSSAlignCenter
                                                     children:@[child1, child2,child3]];
                                
CSSLayoutDiv *div2 =[CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionColumn
                                              justifyContent:CSSJustifySpaceAround
                                                  alignItems:CSSAlignCenter
                                                    children:@[child5,child6,child7,child8]];
root.css_children = @[div1,div2];                                
                                                       
```


### UITableView+CSSLayout

 UITableView+CSSLayout is category of UITableView. It support auto cell height of csslayout and easy use.
 
 ```objc
 [self.tableView css_cellBlockForIndexPath:^UIView *(NSIndexPath *indexPath) {
    return [[CSSFeedView alloc]initWithModel:weakSelf.sections[indexPath.section][indexPath.row]];
  }];
  
  ....
  
  - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView css_heightForIndexPath:indexPath];
  }

  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView css_cellForIndexPath:indexPath];
  }

```

### UIScrollView+CSSLayout

It support auto content size

```objc
  CSSLayoutDiv *root = [CSSLayoutDiv layoutDivWithFlexDirection:CSSFlexDirectionRow
                                                 justifyContent:CSSJustifySpaceAround
                                                     alignItems:CSSAlignCenter
                                                       children:@[div1,div2]];
  
  contentView.css_contentDiv = root;
```

 

## Author

qiang.shen

## License

CSSLayout is available under the MIT license. See the LICENSE file for more info.




