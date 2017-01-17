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
 [root css_setFlexDirection:CSSFlexDirectionRow];
```
![ROW](https://cask.scotch.io/2015/04/flexbox-flex-direction-row.jpg)

```objc
 [root css_setFlexDirection:CSSFlexDirectionRowReverse];
```
![RowReverse](https://cask.scotch.io/2015/04/flexbox-flex-direction-row-reverse.jpg)

```objc
 [root css_setFlexDirection:YGFlexDirectionColumn];
```
![Colum](https://cask.scotch.io/2015/04/flexbox-flex-direction-column.jpg)

```objc
 [root css_setFlexDirection:YGFlexDirectionColumnReverse];
```
![ColumReverse](https://cask.scotch.io/2015/04/flexbox-flex-direction-column-reverse.jpg)

##### flex-wrap

The initial flexbox concept is the container to set its items in one single line. The flex-wrap property controls if the flex container lay out its items in single or multiple lines, and the direction the new lines are stacked in.Supports only 'nowrap' (which is the default) or 'wrap'

```objc
 [root css_setFlexWrap:CSSWrapNoWrap];
```
![noWrap](https://cask.scotch.io/2015/04/flexbox-flex-wrap-nowrap.jpg)

```objc
 [root css_setFlexWrap:CSSWrapWrap];
```
![noWrap](https://cask.scotch.io/2015/04/flexbox-flex-wrap-wrap.jpg)

##### justify-content

The justify-content property aligns flex items along the main axis of the current line of the flex container. It helps distribute left free space when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size.

```objc
 [root css_setJustifyContent:CSSJustifyFlexStart];
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-flex-start.jpg)
```objc
 [root css_setJustifyContent:CSSJustifyCenter];
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-center.jpg)
```objc
 [root css_setJustifyContent:CSSJustifyFlexEnd];
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-flex-end.jpg)
```objc
 [root css_setJustifyContent:CSSJustifySpaceBetween];
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-space-between.jpg)
```objc
 [root css_setJustifyContent:CSSJustifySpaceAround];
```
![JustifyFlexStart](https://cask.scotch.io/2015/04/flexbox-justify-content-space-around.jpg)

##### align-items

Flex items can be aligned in the cross axis of the current line of the flex container, similar to justify-content but in the perpendicular direction. This property sets the default alignment for all flex items, including the anonymous ones.

```objc
 [root css_setAlignItems:CSSAlignFlexStart];
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-items-flex-start.jpg)

```objc
 [root css_setAlignItems:CSSAlignCenter];
```
![CSSAlignCenter](https://cask.scotch.io/2015/04/flexbox-align-items-center.jpg)

```objc
 [root css_setAlignItems:CSSAlignFlexEnd];
```
![CSSAlignFlexEnd](https://cask.scotch.io/2015/04/flexbox-align-items-flex-end.jpg)

```objc
 [root css_setAlignItems:CSSAlignStretch];
```
![CSSAlignStretch](https://cask.scotch.io/2015/04/flexbox-align-items-stretch.jpg)

##### align-content

The align-content property aligns a flex container’s lines within the flex container when there is extra space in the cross-axis, similar to how justify-content aligns individual items within the main-axis.

```objc
 [root css_setAlignContent:CSSAlignFlexStart];
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-flex-start.jpg)


```objc
 [root css_setAlignContent:CSSAlignCenter];
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-center.jpg)


```objc
 [root css_setAlignContent:CSSAlignFlexEnd];
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-flex-end.jpg)


```objc
 [root css_setAlignContent:CSSAlignStretch];
```
![CSSAlignFlexStart](https://cask.scotch.io/2015/04/flexbox-align-content-stretch.jpg)

### Flexbox item properties

##### flex-grow

This property specifies the flex grow factor, which determines how much the flex item will grow relative to the rest of the flex items in the flex container when positive free space is distributed.

```objc
  [child css_setFlexGrow:1.0];
```
![FlexGrow-1.0](https://cask.scotch.io/2015/04/flexbox-flex-grow-1.jpg)
![FlexGrow-3.0](https://cask.scotch.io/2015/04/flexbox-flex-grow-2.jpg)

##### flex-shrink

The flex-shrink specifies the flex shrink factor, which determines how much the flex item will shrink relative to the rest of the flex items in the flex container when negative free space is distributed.

By default all flex items can be shrunk, but if we set it to 0 (don’t shrink) they will maintain the original size
```objc
  [child css_setFlexShrink:0.0];
```
![flex-shrink](https://cask.scotch.io/2015/04/flexbox-flex-shrink.jpg)

##### flex-basis

This property takes the same values as the width and height properties, and specifies the initial main size of the flex item, before free space is distributed according to the flex factors.

```objc
[child css_setFlexBasis:350];
```
![flex-basis](https://cask.scotch.io/2015/04/flexbox-flex-basis.jpg)

##### align-self
This align-self property allows the default alignment (or the one specified by align-items) to be overridden for individual flex items. Refer to align-items explanation for flex container to understand the available values.

```objc
[child css_setAlignSelf:CSSAlignFlexStart];
```
![align-self](https://cask.scotch.io/2015/04/flexbox-align-self.jpg)

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
 

## Author

qiang.shen

## License

CSSLayout is available under the MIT license. See the LICENSE file for more info.




