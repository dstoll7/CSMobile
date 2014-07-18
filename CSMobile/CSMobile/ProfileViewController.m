//
//  ProfileViewController.m
//  CSMobile
//
//  Created by Daniel Stoll on 7/17/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import "ProfileViewController.h"
#import "Stock.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize myStocksArray, dayHighLabel, dayLowLabel, nameLabel, symbolLabel, cusipLabel, myStocksTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myStocksArray = [[NSMutableArray alloc]init];
    myStocksTableView.delegate = self;
    myStocksTableView.dataSource = self;
    [self getMyStocks];
    
    
}


-(void)getMyStocks{
    
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    NSString *jsonUrlString = [NSString stringWithFormat:@"http://ec2-54-86-66-228.compute-1.amazonaws.com/json_businesses.php"];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    // NSLog(@"Result = %@",result);
    
    for (NSMutableDictionary *dic in result)
    {
        
        Stock *newStock = [[Stock alloc]init];
        
        NSString *cusip = dic[@"bid"];
        NSString *name = dic[@"name"];
        
        NSString *symbol = dic[@"state_province"];
        NSString *dayHigh = dic[@"zip_or_postcode"];
        NSString *dayLow = dic[@"country"];
        
        newStock.cusip= cusip;
        newStock.name = name;
        newStock.symbol = symbol;
        newStock.dayHigh = dayHigh;
        newStock.dayLow = dayLow;
        
        
        [myStocksArray addObject:newStock];
        //NSLog(@"%@ %@", newBusiness.name, newBusiness.address1);
        
    }
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myStocksArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    
    Stock *currentStock = [myStocksArray objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        
        //cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 2, 200, 32)];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:22.0]];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:currentStock.name];
    
    cusipLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 200, 32)];
    [cusipLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
    cusipLabel.textAlignment = NSTextAlignmentLeft;
    [cusipLabel setBackgroundColor:[UIColor clearColor]];
    [cusipLabel setText:currentStock.cusip];
    
    symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 200, 32)];
    [symbolLabel setFont:[UIFont boldSystemFontOfSize:11.0]];
    symbolLabel.textAlignment = NSTextAlignmentLeft;
    [symbolLabel setBackgroundColor:[UIColor clearColor]];
    [symbolLabel setText:currentStock.symbol];
    
    
    // dayLowLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 200, 32)];
    // dayHighLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 200, 32)];
    
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:cusipLabel];
    [cell.contentView addSubview:symbolLabel];
    
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (IBAction)searchAction:(id)sender {
}
- (IBAction)settingsAction:(id)sender {
    [self performSegueWithIdentifier:@"toSettingsSegue" sender:self];
    
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
