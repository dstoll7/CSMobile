//
//  StocksViewController.m
//  CSMobile
//
//  Created by Daniel Stoll on 7/18/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import "StocksViewController.h"
#import "StockDetailViewController.h"
#import "FXDetailPage.h"

@interface StocksViewController ()

@property (nonatomic) UISearchDisplayController *searchDispController;
@property (nonatomic) NSMutableArray *searchStocksResults;


@end

@implementation StocksViewController{
    Stock *stockToPass;
    UIActivityIndicatorView *spinner;
    UIPickerView *pickerView;
    UIToolbar *pickerToolbar;
    NSString *currentFX;
    NSMutableArray *fxPriceArray;
    
    NSNumber *rateToPass;
    NSString *quoteToPass;
    NSString *baseToPass;

    

}



@synthesize searchBar, stocksFXControl, stocksArray, cusipLabel, nameLabel, priceLabel, dayHighLabel, dayLowLabel, symbolLabel, stocksTableView, searchDispController, searchStocksResults, selectFXButton, fxArray, fxTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //need to un-hide the navigation bar when coming from login page
    [self.navigationController.navigationBar setHidden:NO];
    
    stocksArray = [[NSMutableArray alloc]init];
    stocksArray = [[NSMutableArray alloc]init];
    fxArray = [[NSMutableArray alloc]initWithObjects:@"USD", @"JPY", @"EUR", @"GBP", @"AUD", @"CAD", @"CHF", @"HKD", nil];

    fxPriceArray = [[NSMutableArray alloc]initWithObjects:@1, @101.5427, @.7428, @.5868, @1.0591, @1.076, @.9024, @7.7504, nil];

   
    
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
    
    
    self.fxTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.searchBar.frame.size.height+ stocksFXControl.frame.size.height+self.navigationController.navigationBar.frame.size.height, 320, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.searchBar.frame.size.height - stocksFXControl.frame.size.height) style:UITableViewStylePlain];//did some math here to make table sit under the nav bar and span to bottom of phone

    fxTableView.delegate = self;
    fxTableView.dataSource = self;

    
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
    
    
    selectFXButton = [[UIButton alloc]initWithFrame:CGRectMake(0, stocksFXControl.frame.size.height+stocksFXControl.frame.origin.y, 320, 44)];
    
    [selectFXButton addTarget:self action:@selector(selectFXCLicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [selectFXButton setTitle:@"Choose Base Currency" forState:UIControlStateNormal];
    [selectFXButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //selectFXButton.layer.borderWidth = 4;
    //selectFXButton.layer.borderColor = [UIColor blackColor].CGColor;
    [selectFXButton setBackgroundColor:[UIColor lightGrayColor]]
    ;

    
    
    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, 180)];
    
    //pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, selectEventView.frame.size.height)];
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    pickerView.showsSelectionIndicator = YES;
    [pickerView setBackgroundColor:[UIColor whiteColor]];
    
    //auto select first row
    
    
    
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(pickerView.frame.origin.x, pickerView.frame.origin.y,320,44)];
    //[pickerToolbar setBarStyle:uiba];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Choose Currency"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(chooseFX:)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                               style:UIBarButtonItemStyleBordered target:self action:@selector(cancelFX:)];
    
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 100;
    
    
    pickerToolbar.items = [[NSArray alloc] initWithObjects:barButtonDone,fixedSpace, cancel,nil];
    //barButtonDone.tintColor=[UIColor lightGrayColor];
    [pickerToolbar setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]];

    
    

}

-(void)getStocks{
    /*
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
    
    //NSMutableDictionary *dic = [NSMutableDictionary alloc]init
    */
    NSArray* stocks = [NSArray arrayWithObjects:
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"AAPL", @"symbol",
                       @"Apple Inc.",@"name",
                       @97.19,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"FB", @"symbol",
                       @"Facebook, Inc.",@"name",
                       @71.29,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"MSFT", @"symbol",
                       @"Microsoft Corporation",@"name",
                       @44.87,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"EMC", @"symbol",
                       @"EMC Corporation",@"name",
                       @28.75,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"BAC", @"symbol",
                       @"Bank of America Corporation",@"name",
                       @15.52,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"JNPR", @"symbol",
                       @"Juniper Networks, Inc.",@"name",
                       @22.43,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"SIRI", @"symbol",
                       @"Sirius XM Holdings Inc.",@"name",
                       @3.46,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"YHOO", @"symbol",
                       @"Yahoo! Inc.",@"name",
                       @34.71,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"TLM", @"symbol",
                       @"Talisman Energy Inc.",@"name",
                       @11.17,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"PLUG", @"symbol",
                       @"Plug Power Inc.",@"name",
                       @5.63,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"XLNX", @"symbol",
                       @"Xilinx Inc.",@"name",
                       @41.26,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"GE", @"symbol",
                       @"General Electric Company",@"name",
                       @25.91,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"AMD", @"symbol",
                       @"Advanced Micro Devices, Inc.",@"name",
                       @3.76,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"F", @"symbol",
                       @"Ford Motor Co.",@"name",
                       @17.78,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"QQQ", @"symbol",
                       @"PowerShares QQQ",@"name",
                       @97.23,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"CSCO", @"symbol",
                       @"Cisco Systems, Inc.",@"name",
                       @25.68,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"RAD", @"symbol",
                       @"Rite Aid Corporation",@"name",
                       @7.29,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"PBR", @"symbol",
                       @"Petr",@"name",
                       @17.15,@"price",
                       nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:
                       @"INTC", @"symbol",
                       @"Intel Corporation",@"name",
                       @34.50,@"price",
                       nil],
                      nil];
    
    @try {
        for (NSMutableDictionary *dic in stocks)
        {
            
            Stock *newStock = [[Stock alloc]init];
            
            NSString *name = dic[@"name"];
            NSString *symbol = dic[@"symbol"];
            NSNumber *price = dic[@"price"];
            
            newStock.name = name;
            newStock.symbol = symbol;
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
            
            [stocksArray addObject:newStock];
            //NSLog(@"%@ %@", newBusiness.name, newBusiness.address1);
            
        }

    }
    @catch (NSException *exception) {
        return;
    }
    @finally {
        return;
    }
    
    
}


- (void)switchViews:(UISegmentedControl *)segment
{
    //if on stocks
    if(segment.selectedSegmentIndex == 0)
    {
        [selectFXButton removeFromSuperview];
        
        [self.searchBar setPlaceholder:@"Search Stocks"];
        [self.view addSubview:stocksTableView];
        [self.view addSubview:searchBar];
        
        
    }
    //else on fx
    else{
        [self.searchBar setPlaceholder:@"Search FX"];
        [stocksTableView removeFromSuperview];
        [searchBar removeFromSuperview];
        
        [self.view addSubview:selectFXButton];
        
        
    }
}


-(void)selectFXCLicked:(id)sender {
    [self.view addSubview:pickerView];
    [self.view addSubview:pickerToolbar];
    
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
        
    }
    else if (tableView == fxTableView){
        return fxArray.count;
    }
    
    else {
        
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
    
    if([fxTableView isDescendantOfView:self.view]){
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 35, 200, 32)];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor blackColor];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setText:[fxArray objectAtIndex:indexPath.row
                            ]];
        
        [cell.contentView addSubview:nameLabel];

        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 30, 200, 32)];
        [priceLabel setFont:[UIFont boldSystemFontOfSize:22.0]];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.textColor = [UIColor blackColor];
        [priceLabel setBackgroundColor:[UIColor clearColor]];
        float price = [[fxPriceArray objectAtIndex:indexPath.row]floatValue];
        [priceLabel setText:[NSString stringWithFormat:@"%.2f", price]];
        
        [cell.contentView addSubview:priceLabel];


        
    }
    
    else{
        
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            currentStock = [searchStocksResults objectAtIndex:indexPath.row];
        } else {
            currentStock = [stocksArray objectAtIndex:indexPath.row];
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
        
        symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 35, 200, 32)];
        [symbolLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
        symbolLabel.textAlignment = NSTextAlignmentLeft;
        symbolLabel.textColor = [UIColor blackColor];
        [symbolLabel setBackgroundColor:[UIColor clearColor]];
        [symbolLabel setText:currentStock.symbol];
        
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 10, 200, 32)];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:11.0]];
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
        [cell.contentView addSubview:symbolLabel];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //go to fx detail
    if([fxTableView isDescendantOfView:self.view]){
        
        baseToPass = selectFXButton.titleLabel.text;
        rateToPass = [fxPriceArray objectAtIndex:indexPath.row];
        quoteToPass = [fxArray objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"toFXDetail" sender:self];
        [self.fxTableView deselectRowAtIndexPath:indexPath animated:YES]; //unhighlight cell after selection
       

    }
    //go to stock detail
    else{
        
        if(tableView == searchDispController.searchResultsTableView){
            stockToPass = [searchStocksResults objectAtIndex:indexPath.row];
        }
        else{
            //send the stock from the selected cell to the next page
            stockToPass = [stocksArray objectAtIndex:indexPath.row];
        }
        
        [self performSegueWithIdentifier:@"toStockDetail" sender:self];
        [self.stocksTableView deselectRowAtIndexPath:indexPath animated:YES]; //unhighlight cell after selection

    }
    
    
    
    
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


#pragma mark - Picker View Stuff

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    /*
     if (myLoadedArray!=nil) {
     return [myLoadedArray count];//this will tell the picker how many rows it has - in this case, the size of your loaded array...
     }
     
     */
    return [fxArray count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //you can also write code here to descide what data to return depending on the component ("column")
    currentFX = [fxArray objectAtIndex:row];
    return [fxArray objectAtIndex:row];
}

// Set title to selected row
-(void)pickerView:(UIPickerView *)mypickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //[addToEventLabel setText:[[pastEventsArray objectAtIndex:row] objectForKey:@"title"]];
    
}


//set event for photo and remove picker
-(void)chooseFX:(id)sender
{
    
    [pickerView removeFromSuperview];
    [pickerToolbar removeFromSuperview];
    //[selectFXButton removeFromSuperview];
    
    [self.view addSubview:fxTableView];
    [selectFXButton setTitle:currentFX forState:UIControlStateNormal];
    
    
    
}

//reset picker and set event to nil
-(void)cancelFX:(id)sender
{
    
    [pickerView removeFromSuperview];
    [pickerToolbar removeFromSuperview];
    
    [pickerView selectRow:0 inComponent:0 animated:YES];
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString: @"toStockDetail"]){
        StockDetailViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.stock = stockToPass;
    }
    
    else if([segue.identifier isEqualToString: @"toFXDetail"]){
        FXDetailPage  *destinationViewController = segue.destinationViewController;
        destinationViewController.rate = rateToPass;
        destinationViewController.base = baseToPass;
        destinationViewController.quote = quoteToPass;
        
    }
}


@end
