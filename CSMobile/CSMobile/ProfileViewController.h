//
//  ProfileViewController.h
//  CSMobile
//
//  Created by Daniel Stoll on 7/17/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *currentBalance;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIToolbar *settingsButton;

@end
