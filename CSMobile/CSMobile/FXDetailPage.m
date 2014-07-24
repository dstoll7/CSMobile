//
//  FXDetailPage.m
//  CSMobile
//
//  Created by Vincent Brown on 7/24/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import "FXDetailPage.h"

@interface FXDetailPage ()

@end

@implementation FXDetailPage{
    NSNumber *total;
}

@synthesize rateTextField, baseLabel, quoteLabel,quantityTextField, totalTextField, submitButton, cancelButton, rate, base, quote;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [baseLabel setText:base];
    [quoteLabel setText:quote];
    float theRate = [rate floatValue];
    [rateTextField setText:[NSString stringWithFormat:@"%.2f", theRate]];
    
    rateTextField.delegate = self;
    quantityTextField.delegate = self;
    totalTextField.delegate = self;
    
    quantityTextField.keyboardType = UIKeyboardTypeDecimalPad;

    
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    quantityTextField.delegate = self;
    NSNumber *quantity = [NSNumber numberWithInt:[quantityTextField.text intValue]];
    total = @([rate floatValue] * [quantity floatValue]);
    float totalAmount = [total floatValue];
    [totalTextField setText:[NSString stringWithFormat:@"" @"%.2f", totalAmount]];
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

- (IBAction)cancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //drops down keyboard when user touches away from keyboard
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {
        [quantityTextField resignFirstResponder];
        //[rateTextField resignFirstResponder];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) index
{
    if ([[alertView buttonTitleAtIndex:index] isEqualToString:@"YES"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:TRUE forKey:@"hasBoughtFX"];
        [defaults synchronize];
        [self performSegueWithIdentifier:@"toProfileSegue" sender:self];
        
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
