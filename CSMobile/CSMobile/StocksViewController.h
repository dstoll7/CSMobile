//
//  StocksViewController.h
//  CSMobile
//
//  Created by Daniel Stoll on 7/18/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"


@interface StocksViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic)  UISegmentedControl *stocksFXControl;
@property (strong, nonatomic)  UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *stocksArray;

@property (strong, nonatomic)  UITableView *currentTable;
@property (strong, nonatomic)  UITableView *stocksTableView;

@property (strong, nonatomic) UILabel *cusipLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *symbolLabel;
@property (strong, nonatomic) UILabel *dayHighLabel;
@property (strong, nonatomic) UILabel *dayLowLabel;
@end
