//
//  TradeViewController.h
//  CSMobile
//
//  Created by Daniel Stoll on 7/17/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stock.h"

@interface TradeViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *buySellControl;

@property (nonatomic) Stock *stock;
@property (atomic) NSNumber *total; 

@end
