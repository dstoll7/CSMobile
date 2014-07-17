//
//  LoginViewController.m
//  CSMobile
//
//  Created by Daniel Stoll on 7/16/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameTextField, passwordTextField;

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
    
    //hide the navigation bar
    [self.navigationController.navigationBar setHidden:YES];

    
    // gives view control of text field
    usernameTextField.delegate = self;
    passwordTextField.delegate = self;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //drops down keyboard when user touches away from keyboard
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {
        [usernameTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
    }
}

//drops down keyboard when user hits return button
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)LoginAction:(id)sender {
    
    //allows current session to be saved for reuse
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:@"isLoggedIn"];
    [defaults synchronize];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];

}
- (IBAction)forgotPasswordAction:(id)sender {
}
- (IBAction)viewStocksAction:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)SignUp:(UIButton *)sender {
}
@end
