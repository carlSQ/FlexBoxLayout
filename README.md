# CSSLayout

[![CI Status](http://img.shields.io/travis/qiang.shen/CSSLayout.svg?style=flat)](https://travis-ci.org/qiang.shen/CSSLayout)
[![Version](https://img.shields.io/cocoapods/v/CSSLayout.svg?style=flat)](http://cocoapods.org/pods/CSSLayout)
[![License](https://img.shields.io/cocoapods/l/CSSLayout.svg?style=flat)](http://cocoapods.org/pods/CSSLayout)
[![Platform](https://img.shields.io/cocoapods/p/CSSLayout.svg?style=flat)](http://cocoapods.org/pods/CSSLayout)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

CSSLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CSSLayout"
```

## usage

```objc
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

[child6 setMargin:10 forEdge:CSSEdgeAll];
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
[div2 setWidth:150];
[div2 setMargin:20 forEdge:CSSEdgeTop];
root.children = @[div2];
[root asyApplyLayoutWithSize:[UIScreen mainScreen].bounds];
```

## Author

qiang.shen, qiang..shen@ele.me

## License

CSSLayout is available under the MIT license. See the LICENSE file for more info.




