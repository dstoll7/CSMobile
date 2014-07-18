//
//  Stock.h
//  CSMobile
//
//  Created by Vincent Brown on 7/18/14.
//  Copyright (c) 2014 Daniel Stoll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stock : NSObject

@property (nonatomic,strong) NSString *cusip;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *symbol;
@property (nonatomic,strong) NSString *dayHigh;
@property (nonatomic,strong) NSString *dayLow;


@end
