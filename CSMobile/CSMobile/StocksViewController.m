//
//  StocksViewController.m
//  CSMobile
//
//  Created by Daniel Stoll on 7/18/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import "StocksViewController.h"
#import "StockDetailViewController.h"
@interface StocksViewController ()

@property (nonatomic) UISearchDisplayController *searchDispController;

@end

@implementation StocksViewController{
    Stock *stockToPass;

}



@synthesize searchBar, stocksFXControl, stocksArray, cusipLabel, nameLabel, dayHighLabel, dayLowLabel, symbolLabel, stocksTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //need to un-hide the navigation bar when coming from login page
    [self.navigationController.navigationBar setHidden:NO];
    
    stocksArray = [[NSMutableArray alloc]init];
    
    stocksTableView.delegate = self;
    stocksTableView.dataSource = self;
    stocksTableView.layer.borderWidth = 4.0;
    stocksTableView.layer.borderColor = [UIColor redColor].CGColor;
    
    self.searchBar.delegate = self;
    [self.searchBar setPlaceholder:@"Search Stocks"];
    /*
    self.searchDispController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDispController.delegate = self;
    self.searchDispController.searchResultsDataSource = self;
    [self.searchDispController.searchResultsTableView setRowHeight:70];
     */
    //self.searchBar.barTintColor = [UIColor colorWithRed:.73725 green:.78431 blue: .9921 alpha:1.0];
    
    [stocksFXControl addTarget:self action:@selector(switchViews:) forControlEvents: UIControlEventValueChanged];
    [self getStocks];

}

-(void)getStocks{
    
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
        
        
        [stocksArray addObject:newStock];
        //NSLog(@"%@ %@", newBusiness.name, newBusiness.address1);
        
    }
    
}



- (void)switchViews:(UISegmentedControl *)segment
{
    //if on stocks
    if(segment.selectedSegmentIndex == 0)
    {
        [self.searchBar setPlaceholder:@"Search Stocks"];

    }
    //else on fx
    else{
        [self.searchBar setPlaceholder:@"Search FX"];

    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //drops down keyboard when user touches away from keyboard
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {
        [self.searchBar resignFirstResponder];
    }
}

//drops down keyboard when user hits return button
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return stocksArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    
    Stock *currentStock = [stocksArray objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        
        //cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.backgroundColor = [UIColor blackColor];
        
    }
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 35, 200, 32)];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:11.0]];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor whiteColor];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setText:currentStock.name];
    
    cusipLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 30, 200, 32)];
    [cusipLabel setFont:[UIFont boldSystemFontOfSize:22.0]];
    cusipLabel.textAlignment = NSTextAlignmentRight;
    cusipLabel.textColor = [UIColor whiteColor];
    [cusipLabel setBackgroundColor:[UIColor clearColor]];
    [cusipLabel setText:currentStock.cusip];
    
    symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 10, 200, 32)];
    [symbolLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
    symbolLabel.textAlignment = NSTextAlignmentLeft;
    symbolLabel.textColor = [UIColor whiteColor];
    [symbolLabel setBackgroundColor:[UIColor clearColor]];
    [symbolLabel setText:currentStock.symbol];
    
    
    // dayLowLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 200, 32)];
    // dayHighLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 200, 32)];
    
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:cusipLabel];
    [cell.contentView addSubview:symbolLabel];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //send the stock from the selected cell to the next page
    stockToPass = [stocksArray objectAtIndex:indexPath.row];
    //go to stock detail
    [self performSegueWithIdentifier:@"toStockDetail" sender:self];
    [self.stocksTableView deselectRowAtIndexPath:indexPath animated:YES]; //unhighlight cell after selection
    
    
    
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
