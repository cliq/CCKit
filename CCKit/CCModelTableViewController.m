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

- (id)init
{
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (UITableView *)tableView;
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 400.0f)
                                                  style:self.tableViewStyle];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)loadView;
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = self.view.bounds;
    self.tableView.frame = rect;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.tableView.hidden = YES;
}

- (void)refreshDataSource;
{
    // Refresh sections calculations
}

#pragma mark - CCModelViewController

- (void)showLoading:(BOOL)show;
{
    if (show) {
        CCDebug(@"Started loading...");
    } else {
        CCDebug(@"Finished loading...");
    }
}

- (void)showError:(BOOL)show;
{
    if (show) {
        CCDebug(@"Error loading model %@:\n%@", self.model, self.modelError);
    }
}

- (void)showEmpty:(BOOL)show;
{
    if (show) {
        CCDebug(@"Empty model.");
    }
}


- (void)showModel:(BOOL)show;
{
    self.tableView.hidden = !show;
    
    if (show) {
        [self refreshDataSource];
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
