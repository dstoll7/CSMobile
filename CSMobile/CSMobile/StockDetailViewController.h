//
//  StockDetailViewController.h
//  CSMobile
//
//  Created by Vincent Brown on 7/20/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"

@interface StockDetailViewController : UIViewController
@property (nonatomic) Stock *stock;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockSymbolLabel;

@end
