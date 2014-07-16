//
//  CSMobileDetailViewController.h
//  CSMobile
//
//  Created by Daniel Stoll on 7/16/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMobileDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
