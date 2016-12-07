//
//  ViewController.m
//  DownJacketSearchBarDemo
//
//  Created by zhanghao on 16/11/11.
//  Copyright © 2016年 zhanghao. All rights reserved.
//

#import "ViewController.h"
#import "DownJacketSearchBar.h"
#import "UIView+DownJacketLayout.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, DownJacketSearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) DownJacketSearchBar *searchBar;

@end

@implementation ViewController

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = @[].mutableCopy;
        for (int i = 0, j = 1; i < 10; i++, j++) {
            if (j > 5) j -= 5;
            NSString *icon = [NSString stringWithFormat:@"zootopia%ld", (long)j];
            DownJackets *m = [DownJackets new];
            m.image = [UIImage imageNamed:icon];
            [_dataList addObject:m];
        }
    }
    return _dataList;
}

- (void)customViews {
    _searchBar = [DownJacketSearchBar new];
    _searchBar.y = 64;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索";
    _searchBar.presetImage = [UIImage imageNamed:@"downJacket_search"];
    _searchBar.leftPadding = 10;
    [self.view addSubview:_searchBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, self.view.width, self.view.height-_searchBar.height - 64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = UIView.new;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.editing = YES;
    _tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self customViews];
}

#pragma mark - DownJacketSearchBarDelegate

- (void)searchBar:(DownJacketSearchBar *)searchBar removeDownJackets:(DownJackets *)downJackets {
    NSInteger index = [self.dataList indexOfObject:downJackets];
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    DownJackets *d = self.dataList[indexPath.row];
    [cell.imageView setImage:d.image];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DownJackets *d = self.dataList[indexPath.row];
    [_searchBar addDownJackets:d];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    DownJackets *d = self.dataList[indexPath.row];
    [_searchBar removeDownJackets:d];
}

- ( UITableViewCellEditingStyle )tableView:( UITableView *)tableView editingStyleForRowAtIndexPath:( NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
