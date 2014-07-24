//
//  FXDetailPage.h
//  CSMobile
//
//  Created by Vincent Brown on 7/24/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXDetailPage : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *baseLabel;
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;
@property (weak, nonatomic) IBOutlet UITextField *rateTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) NSNumber *rate;
@property (strong, nonatomic) NSString *base;
@property (strong, nonatomic) NSString *quote;

@end
