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
@property (nonatomic) NSMutableArray *searchStocksResults;


@end

@implementation StocksViewController{
    Stock *stockToPass;
    UIActivityIndicatorView *spinner;


}



@synthesize searchBar, stocksFXControl, stocksArray, cusipLabel, nameLabel, dayHighLabel, dayLowLabel, symbolLabel, stocksTableView, searchDispController, searchStocksResults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //need to un-hide the navigation bar when coming from login page
    [self.navigationController.navigationBar setHidden:NO];
    
    stocksArray = [[NSMutableArray alloc]init];
    
   
    
    stocksFXControl = [[UISegmentedControl alloc]initWithItems:@[@"Stocks",@"FX"]];
    
    //self.stocksFXControl.segmentedControlStyle = UISegmentedControlStyleBar;

    stocksFXControl.frame = CGRectMake(-2, [UIApplication sharedApplication].statusBarFrame.size.height +self.navigationController.navigationBar.frame.size.height, 330, 30);
    
    [stocksFXControl setTintColor: [UIColor colorWithRed:148/255.0 green:191/255.0 blue:228/255.0 alpha:1.0]];

    [stocksFXControl setSelectedSegmentIndex:0];
    
    //initialize the search bar for the contacts page
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, stocksFXControl.frame.size.height+stocksFXControl.frame.origin.y, 320, 44)];
    self.searchBar.delegate = self;
    [self.searchBar setPlaceholder:@"Search Stocks"];
    
    self.searchDispController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    //Contact Table setup
    self.stocksTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.searchBar.frame.size.height+ stocksFXControl.frame.size.height+self.navigationController.navigationBar.frame.size.height, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.searchBar.frame.size.height - stocksFXControl.frame.size.height) style:UITableViewStylePlain];//did some math here to make table sit under the nav bar and span to bottom of phone
   
    stocksTableView.delegate = self;
    stocksTableView.dataSource = self;
//    stocksTableView.layer.borderWidth = 4.0;
//    stocksTableView.layer.borderColor = [UIColor redColor].CGColor;
    
    
    
    self.searchDispController.delegate = self;
    self.searchDispController.searchResultsDelegate = self;
    self.searchDispController.searchResultsDataSource = self;
    [self.searchDispController.searchResultsTableView setRowHeight:90];

    
    //add contacts table and search bar to initial view
    [self.view addSubview:stocksTableView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:stocksFXControl];

    
    
    //create spinner view
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.frame = CGRectMake(0, 0, 320, 350);
    [spinner setColor:[UIColor redColor]];
    
    //self.edgesForExtendedLayout = UIRectEdgeLeft | [UIRectEdgeBottom] | UIRectEdgeRight;
    //self.edgesForExtendedLayout = UIRectEdgeNone;

    
    //self.searchBar.barTintColor = [UIColor colorWithRed:.73725 green:.78431 blue: .9921 alpha:1.0];
    
    [stocksFXControl addTarget:self action:@selector(switchViews:) forControlEvents: UIControlEventValueChanged];
    dispatch_queue_t queue = dispatch_queue_create("credit.suisse.GetStocks", NULL);
    dispatch_async(queue, ^{
        
        
        [self.stocksTableView addSubview:spinner];
        [spinner startAnimating];
        [self getStocks];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [self.stocksTableView reloadData];
            self.searchStocksResults = [NSMutableArray arrayWithCapacity:self.stocksArray.count];

            
            [spinner stopAnimating];
            [spinner removeFromSuperview];
        });
    });
    //[self getStocks];

}

-(void)getStocks{
    
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    //project server
//    NSString *jsonUrlString = [NSString stringWithFormat:@"http://192.168.3.147:7001/SuisseTrade/rest/stockTest/GOOG/432.5"];
    
    //DeShawn's test server
    NSString *jsonUrlString = [NSString stringWithFormat:@"http://ec2-54-86-66-228.compute-1.amazonaws.com/json_businesses.php"];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
     //NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
/*
    for(id key in result) {
        
        id value = [result objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
*/
    
    NSLog(@"Response Data = %@", responseData);
    NSLog(@"Result = %@", result);
    
    for (NSMutableDictionary *dic in result)
    {
        
        Stock *newStock = [[Stock alloc]init];
        NSLog(@"dic = %@",dic);
        
//        NSString *cusip = @"Google"; //dic[@"bid"];
//        NSString *name = dic[@"name"];
//        
//        NSString *symbol = dic[@"price"];
//        NSString *dayHigh = @"";//dic[@"zip_or_postcode"];
//        NSString *dayLow = @"";//dic[@"country"];
        
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

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //drops down keyboard when user touches away from keyboard
    UITouch *touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan)
    {
        [self.searchBar resignFirstResponder];
    }
}*/

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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
       
        return [searchStocksResults count];
        
    } else {
        
        return stocksArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    Stock *currentStock;
    //currentStock = [stocksArray objectAtIndex:indexPath.row];

    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        
        //cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.backgroundColor = [UIColor whiteColor];
        
    }
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        currentStock = [searchStocksResults objectAtIndex:indexPath.row];
    } else {
        currentStock = [stocksArray objectAtIndex:indexPath.row];
    }
    
    
    
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

- (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
    if ((productName == nil) || [productName length] == 0)
    {
        // If there is no search string and the scope is "All".
        
        self.searchStocksResults = [self.stocksArray mutableCopy];
        return;
    }
    
    
    [self.searchStocksResults removeAllObjects]; // First clear the stocsk filtered array.
	/*
	 Search the main list for hotSpots whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
   
    Stock *currentStock;
    NSString *stockName;
    //NSString *stockSymbol;
    
    
    for(int i = 0; i < self.stocksArray.count; i++){
        
        stockName = currentStock.name;
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange searchNameRange = NSMakeRange(0, stockName.length);
        NSRange foundNameRange = [stockName rangeOfString:productName options:searchOptions range:searchNameRange];
        if (foundNameRange.length > 0)
        {
            [self.searchStocksResults addObject:currentStock];
        }
        /*
        else {
            number = [userWithApp.user valueForKey:@"phoneNumber"];
            NSRange searchNumRange = NSMakeRange(0, number.length);
            NSRange foundNumRange = [number rangeOfString:productName options:searchOptions range:searchNumRange];
            if (foundNumRange.length > 0)
            {
                [self.searchUsersResults addObject:userWithApp];
            }
        }*/
    }
    
   
    
}


#pragma mark - UISearchDisplayController Delegate Methods



- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchStocksResults = [NSMutableArray arrayWithArray:[stocksArray filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //self.stocksTableView = searchDispController.searchResultsTableView;
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
   
    [stocksFXControl removeFromSuperview];
    
    return true;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{

    [self.view addSubview:stocksFXControl];
    return true;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{

    if([stocksFXControl isDescendantOfView:self.view]){
        [stocksFXControl removeFromSuperview];
    }
    
    self.searchBar.frame = CGRectMake(0,[UIApplication sharedApplication].statusBarFrame.size.height, 320, 44);
    self.stocksTableView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.searchBar.frame.size.height, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.searchBar.frame.size.height);
   
    
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView{
    
    if(![stocksFXControl isDescendantOfView:self.view]){
        [self.view addSubview:stocksFXControl];
    }
    self.searchBar.frame = CGRectMake(0, stocksFXControl.frame.size.height+stocksFXControl.frame.origin.y, 320, 44);

    self.stocksTableView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.searchBar.frame.size.height+ stocksFXControl.frame.size.height+self.navigationController.navigationBar.frame.size.height, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.searchBar.frame.size.height - stocksFXControl.frame.size.height);
}

/*
-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    self.searchBar.frame = CGRectMake(0, 0, 320, 44);
    self.stocksTableView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.searchBar.frame.size.height, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.searchBar.frame.size.height);
   // [toolbar removeFromSuperview];
    
    
}
-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    self.searchBar.frame = CGRectMake(0, self.stocksFXControl.frame.size.height, 320, 44);
    self.stocksTableView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.searchBar.frame.size.height+ stocksFXControl.frame.size.height, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.searchBar.frame.size.height);
    //[self.view addSubview:toolbar];
    
    
}

*/

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
