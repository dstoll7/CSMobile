//
//  ProfileViewController.h
//  CSMobile
//
//  Created by Daniel Stoll on 7/17/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *currentBalance;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIToolbar *settingsButton;
@property (strong, nonatomic) NSMutableArray *myStocksArray;

@property (strong, nonatomic) UILabel *cusipLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *symbolLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *dayHighLabel;
@property (strong, nonatomic) UILabel *dayLowLabel;
@property (weak, nonatomic) IBOutlet UITableView *myStocksTableView;

@end
