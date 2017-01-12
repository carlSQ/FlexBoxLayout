//
//  CSSFeedModel.m
//  CSSLayout
//
//  Created by 沈强 on 2017/1/11.
//  Copyright © 2017年 qiang.shen. All rights reserved.
//

#import "CSSFeedModel.h"

@implementation CSSFeedModel


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
  self = super.init;
  if (self) {
    _title = dictionary[@"title"];
    _content = dictionary[@"content"];
    _username = dictionary[@"username"];
    _time = dictionary[@"time"];
    _imageName = dictionary[@"imageName"];
  }
  return self;
}



@end
