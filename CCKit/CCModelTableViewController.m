//
//  CCModelTableViewController.m
//  CCKit
//
//  Created by Leonardo Lobato on 3/4/13.
//  Copyright (c) 2013 Cliq Consulting. All rights reserved.
//

#import "CCModelTableViewController.h"

@interface CCModelTableViewController ()

@end

@implementation CCModelTableViewController

@synthesize tableView = _tableView;

- (UITableView *)tableView;
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 400.0f)
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)loadView;
{
    [super loadView];
    
    CGRect rect = self.view.bounds;
    self.tableView.frame = rect;
    [self.view addSubview:self.tableView];
}

#pragma mark - CCModelViewController

- (void)showModel:(BOOL)show;
{
    self.tableView.hidden = !show;
    if (show) {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return nil;
}

@end
