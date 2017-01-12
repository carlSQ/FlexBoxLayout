//
//  CSSTableViewController.m
//  CSSLayout
//
//  Created by 沈强 on 2017/1/11.
//  Copyright © 2017年 qiang.shen. All rights reserved.
//

#import "CSSTableViewController.h"
#import "CSSFeedModel.h"
#import "UITableView+CSSLayout.h"
#import "CSSFeedView.h"
#import "CSSFPSGraph.h"

@interface CSSTableViewController ()

@property(nonatomic, strong)NSMutableArray *feeds;

@end

@implementation CSSTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
  NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
  NSArray *feedDicts = rootDict[@"feed"];
  
  _feeds = @[].mutableCopy;
  
  [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [_feeds addObject:[[CSSFeedModel alloc] initWithDictionary:obj]];
  }];
  
  __weak typeof(self)weakSelf = self;
  
  [self.tableView css_cellBlockForIndexPath:^UIView *(NSIndexPath *indexPath) {
    return [[CSSFeedView alloc]initWithModel:weakSelf.feeds[indexPath.row]];
  }];
  [self.tableView reloadData];
 CSSFPSGraph *graph =  [[CSSFPSGraph alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 30)
                               color:[UIColor lightGrayColor]];
  [[UIApplication sharedApplication].keyWindow addSubview:graph];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _feeds.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.tableView css_heightForIndexPath:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.tableView css_cellForIndexPath:indexPath];
}

@end
