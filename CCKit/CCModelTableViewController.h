//
//  CCModelTableViewController.h
//  CCKit
//
//  Created by Leonardo Lobato on 3/4/13.
//  Copyright (c) 2013 Cliq Consulting. All rights reserved.
//

#import "CCModelViewController.h"

@interface CCModelTableViewController : CCModelViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
