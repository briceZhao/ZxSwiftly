//
//  ViewController.m
//  SwiftlyDemo
//
//  Created by brice Mac on 2017/4/21.
//  Copyright © 2017年 briceZhao. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

#import "ViewController.h"
#import <ZxExtension.h>
#import <UIViewController+ZXExtension.h>
#import <Masonry.h>
#import "UIView+SeparatorLine.h"
#import "ZXDropMenuView.h"
#import "ZXDropMenuItem.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) ZXDropMenuView *menu;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.zx_interactiveNavigationBarHidden = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"SwiftlyDemo"];
    [self.navigationBar pushNavigationItem:item animated:NO];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.view addSubview:self.navigationBar];
    
    [self setupMenu];
    
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menu.bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"re"];
}


- (void)setupMenu {
    
    ZXDropMenuItem *item1 = [[ZXDropMenuItem alloc]
                             initWithTitle:@"分类"
                             options:@[@"裙子", @"上衣", @"裤子", @"鞋子", @"包包", @"套装", @"儿童装", @"配饰", @"美妆个护"]
                             image:[UIImage imageNamed:@"filter_category_normal"]
                             selectedImage:[UIImage imageNamed:@"filter_category_selected"]];
    
    ZXDropMenuItem *item2 = [[ZXDropMenuItem alloc]
                             initWithTitle:@"筛选"
                             options:@[]
                             image:[UIImage imageNamed:@"filter_filter_normal"]
                             selectedImage:[UIImage imageNamed:@"filter_filter_selected"]];
    
    ZXDropMenuItem *item3 = [[ZXDropMenuItem alloc]
                             initWithTitle:@"排序"
                             options:@[@"热销款", @"最新款", @"价格从低到高", @"价格从高到低"]
                             image:[UIImage imageNamed:@"filter_sort"]
                             selectedImage:[UIImage imageNamed:@"filter_sort"]
                             initialOptionIndex:0];
    
    ZXDropMenuView *menu = [[ZXDropMenuView alloc]init];
    self.menu = menu;
    [self.view addSubview: menu];
    
    [menu makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(40.f);
    }];
    
    item1.usingOptionAsTitle = YES;
    
    menu.items = @[item1, item2, item3];
    
    @weakify(self);
    [[RACObserve(item1, selectedOptionIndex) skip:1] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        
        [self.tableView setScrollsToTop:YES];
        
    }];
    
    [item2.itemClickSignal subscribeNext:^(ZXDropMenuItem * _Nullable x) {
        @strongify(self);
        
        [self.navigationController pushViewController:[UITableViewController new] animated:YES];
        [self.menu dismissDropMenuWithAnimated:NO];
        
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationBar.shadowImage = [[UIImage alloc]init];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self followScrollView:self.tableView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"re" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewController *vc = [[UITableViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end


