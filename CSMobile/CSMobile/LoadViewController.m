//
//  LoadViewController.m
//  CSMobile
//
//  Created by Daniel Stoll on 7/17/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import "LoadViewController.h"

@interface LoadViewController ()

@end

@implementation LoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // check if user is already Logged in and direct to appropriate screen
    if([defaults boolForKey:@"isLoggedIn"]==0)
    {
        [defaults setBool:FALSE forKey:@"isLoggedIn"];
        [defaults synchronize];
        
    }

    if ([defaults boolForKey:@"isLoggedIn"]==FALSE)
    {
        [self performSegueWithIdentifier:@"toLoginSegue" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"toHomeSegue" sender:self];

    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
