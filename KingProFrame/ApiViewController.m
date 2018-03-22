//
//  ApiViewController.m
//  KingProFrame
//
//  Created by denglong on 11/6/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "ApiViewController.h"

@interface ApiViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *apiLists;
    NSArray *apiNames;
}

@end

@implementation ApiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
//    apiLists = @[@"https://dev.eqbang.cn/api/", @"https://dev1.eqbang.cn/api/", @"https://dev2.eqbang.cn/api/", @"https://dev3.eqbang.cn/api/", @"https://dev4.eqbang.cn/api/", @"https://test.eqbang.cn/api/", @"https://test1.eqbang.cn/api/", @"https://test2.eqbang.cn/api/", @"https://test3.eqbang.cn/api/", @"https://test4.eqbang.cn/api/", @"http://api.eqbang.cn/api/"];
    apiLists = @[@"http://dev.eqb.com/api/", @"http://dev1.eqb.com/api/", @"http://dev2.eqb.com/api/", @"http://dev3.eqb.com/api/", @"http://dev4.eqb.com/api/", @"http://test.eqb.com/api/", @"http://test1.eqb.com/api/", @"http://test2.eqb.com/api/", @"http://test3.eqb.com/api/", @"http://test4.eqb.com/api/", @"http://api.eqbang.cn/api/"];
//    apiNames = @[@"开发环境:https://dev.eqbang.cn/api/", @"开发环境:https://dev1.eqbang.cn/api/", @"开发环境:https://dev2.eqbang.cn/api/", @"开发环境:https://dev3.eqbang.cn/api/", @"开发环境:https://dev4.eqbang.cn/api/", @"测试环境:https://test.eqbang.cn/api/", @"测试环境:https://test1.eqbang.cn/api/", @"测试环境:https://test2.eqbang.cn/api/", @"测试环境:https://test3.eqbang.cn/api/", @"测试环境:https://test4.eqbang.cn/api/", @"线上环境:http://api.eqbang.cn/api/"];
    apiNames = @[@"开发环境:http://dev.eqb.com/api/", @"开发环境:http://dev1.eqb.com/api/", @"开发环境:http://dev2.eqb.com/api/", @"开发环境:http://dev3.eqb.com/api/", @"开发环境:http://dev4.eqb.com/api/", @"测试环境:http://test.eqb.com/api/", @"测试环境:http://test1.eqb.com/api/", @"测试环境:http://test2.eqb.com/api/", @"测试环境:http://test3.eqb.com/api/", @"测试环境:http://test4.eqb.com/api/", @"线上环境:http://api.eqbang.cn/api/"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return apiNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Contentidentifier = @"_ContentCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Contentidentifier];
    if (cell == nil){
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Contentidentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = apiNames[indexPath.row];
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] setObject:apiLists[indexPath.row] forKey:@"APINAME"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
