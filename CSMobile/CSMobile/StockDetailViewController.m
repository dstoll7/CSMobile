//
//  StockDetailViewController.m
//  CSMobile
//
//  Created by Vincent Brown on 7/20/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import "StockDetailViewController.h"
#import "TradeViewController.h"

@interface StockDetailViewController ()

@end

@implementation StockDetailViewController

@synthesize stockNameLabel, stockPriceLabel,stockSymbolLabel, stock;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [stockNameLabel setText:stock.name];
    [stockSymbolLabel setText:stock.symbol];
    [stockPriceLabel setText:[NSString stringWithFormat:@"$%@", stock.dayHigh]];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString: @"tradeStockSegue"]){
        TradeViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.stock = self.stock;
    }
}

@end
