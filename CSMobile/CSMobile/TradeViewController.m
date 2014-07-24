//
//  TradeViewController.m
//  CSMobile
//
//  Created by Daniel Stoll on 7/17/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import "TradeViewController.h"

@interface TradeViewController ()

@end

@implementation TradeViewController
@synthesize quantityTextField, totalTextField, priceTextField, total, stockNameLabel, stock, cancelButton;



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    quantityTextField.delegate = self;
    quantityTextField.keyboardType = UIKeyboardTypeDecimalPad;
    priceTextField.delegate = self;
    totalTextField.delegate = self;
    
    [stockNameLabel setText:stock.name];
    float price = [stock.price floatValue];
    [priceTextField setText:[NSString stringWithFormat:@"$" @"%.2f", price]];
    [priceTextField setUserInteractionEnabled:NO];
    
    [totalTextField setUserInteractionEnabled:NO];
    

}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    quantityTextField.delegate = self;
    NSNumber *quantity = [NSNumber numberWithInt:[quantityTextField.text intValue]];
    total = @([stock.price floatValue] * [quantity floatValue]);
    float totalAmount = [total floatValue];
    [totalTextField setText:[NSString stringWithFormat:@"$" @"%.2f", totalAmount]];
}

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)submitClicked:(id)sender {
    // open a alert with an OK and cancel button
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
                                          message:@"Are you sure you would like to make this transaction?"
                                          delegate:self
                                          cancelButtonTitle: @"NO"
                                          otherButtonTitles:@"YES", nil];
    [alert show];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) index
{
    if ([[alertView buttonTitleAtIndex:index] isEqualToString:@"YES"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:TRUE forKey:@"hasBoughtStock"];
        [defaults synchronize];
        [self performSegueWithIdentifier:@"toProfileSegue" sender:self];
        
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //drops down keyboard when user touches away from keyboard
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {
        [quantityTextField resignFirstResponder];
        [priceTextField resignFirstResponder];
    }
}

//drops down keyboard when user hits return button
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

@end
