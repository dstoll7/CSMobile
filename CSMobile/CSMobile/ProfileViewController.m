//
//  ProfileViewController.m
//  CSMobile
//
//  Created by Daniel Stoll on 7/17/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import "ProfileViewController.h"
#import "Stock.h"
#import "QuartzCore/QuartzCore.h"
#import "StockDetailViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController{
    Stock *stockToPass;
    UIActivityIndicatorView *spinner;


    
}

@synthesize myStocksArray, dayHighLabel, dayLowLabel, nameLabel, priceLabel, symbolLabel, cusipLabel, myStocksTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myStocksArray = [[NSMutableArray alloc]init];
    myStocksTableView.delegate = self;
    myStocksTableView.dataSource = self;
    myStocksTableView.layer.borderWidth = 4.0;
//    myStocksTableView.layer.borderColor = [UIColor redColor].CGColor;
    myStocksTableView.layer.borderColor = [UIColor colorWithRed:148/255.0 green:191/255.0 blue:228/255.0 alpha:1.0].CGColor;
    
    
    
    //create spinner view
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.frame = CGRectMake(0, 0, 320, 350);
    [spinner setColor:[UIColor redColor]];
    
    //[self getMyStocks];

    
    
    //do fetches in background
    dispatch_queue_t queue = dispatch_queue_create("credit.suisse.GetStocks", NULL);
    dispatch_async(queue, ^{
        
        
        [self.myStocksTableView addSubview:spinner];
        [spinner startAnimating];
        [self getMyStocks];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.myStocksTableView reloadData];
            
            
            [spinner stopAnimating];
            [spinner removeFromSuperview];
        });
    });

    
    
    
}


-(void)getMyStocks{
    
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    //project server
    NSString *jsonUrlString = [NSString stringWithFormat:@"http://192.168.3.147:7001/SuisseTrade/rest/stockTest/GOOG/432.5"];
    
    //DeShawn's test server
    //    NSString *jsonUrlString = [NSString stringWithFormat:@"http://ec2-54-86-66-228.compute-1.amazonaws.com/json_businesses.php"];
    
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
        
        NSString *name = dic[@"name"];
        NSNumber *price = dic[@"price"];
        
        newStock.name = name;
        newStock.price = price;
        
        
        
        /*
         NSString *cusip = dic[@"bid"];
         NSString *name = dic[@"name"];
         
         NSString *symbol = dic[@"price"];
         NSString *dayHigh = dic[@"zip_or_postcode"];
         NSString *dayLow = dic[@"country"];
         
         newStock.cusip= cusip;
         newStock.name = name;
         newStock.symbol = symbol;
         newStock.dayHigh = dayHigh;
         newStock.dayLow = dayLow;
         */
        
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
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    
    /*
     nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 35, 200, 32)];
     [nameLabel setFont:[UIFont boldSystemFontOfSize:11.0]];
     nameLabel.textAlignment = NSTextAlignmentLeft;
     nameLabel.textColor = [UIColor blackColor];
     [nameLabel setBackgroundColor:[UIColor clearColor]];
     [nameLabel setText:currentStock.name];
     
     cusipLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 30, 200, 32)];
     [cusipLabel setFont:[UIFont boldSystemFontOfSize:22.0]];
     cusipLabel.textAlignment = NSTextAlignmentRight;
     cusipLabel.textColor = [UIColor blackColor];
     [cusipLabel setBackgroundColor:[UIColor clearColor]];
     [cusipLabel setText:currentStock.cusip];
     
     symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 10, 200, 32)];
     [symbolLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
     symbolLabel.textAlignment = NSTextAlignmentLeft;
     symbolLabel.textColor = [UIColor blackColor];
     [symbolLabel setBackgroundColor:[UIColor clearColor]];
     [symbolLabel setText:currentStock.price];
     */
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 35, 200, 32)];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:currentStock.name];
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 30, 200, 32)];
    [priceLabel setFont:[UIFont boldSystemFontOfSize:22.0]];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.textColor = [UIColor blackColor];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    float price = [currentStock.price floatValue];
    [priceLabel setText:[NSString stringWithFormat:@"%.2f", price]];
    
    
    // dayLowLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 200, 32)];
    // dayHighLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 200, 32)];
    
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:priceLabel];
    //    [cell.contentView addSubview:symbolLabel];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //send the stock from the selected cell to the next page
    stockToPass = [myStocksArray objectAtIndex:indexPath.row];
    //go to stock detail
    [self performSegueWithIdentifier:@"toStockDetail" sender:self];
    [self.myStocksTableView deselectRowAtIndexPath:indexPath animated:YES]; //unhighlight cell after selection

    
    
}
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}*/




- (IBAction)settingsAction:(id)sender {
    [self performSegueWithIdentifier:@"toSettingsSegue" sender:self];
    
}



 #pragma mark - Navigation


 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if([segue.identifier isEqualToString: @"toStockDetail"]){
         StockDetailViewController *destinationViewController = segue.destinationViewController;
         destinationViewController.stock = stockToPass;
     }
 }


@end
