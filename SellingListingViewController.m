//
//  SellingListingViewController.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/16/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "SellingListingViewController.h"

@implementation SellingListingViewController {
    Listing *data;
    SellingListingView *slv;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    slv = [[SellingListingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * .8, self.view.frame.size.height-60)];
    [slv setData:data];
    [self.view addSubview:slv];
}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar.topItem setTitle:@""];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)setListing:(Listing *)listing {
    data = listing;
    NSString *sport = [[NSString alloc] initWithString:[[SportsAppApi sharedInstance] convertToDisplayNameWithCatagoryName:[listing.attrs objectForKey:@"sport"]]];
    NSString *dateString = [[NSString alloc] initWithString:listing.getStartingDateString];
    NSRange range = [dateString rangeOfString:@"at"];
    NSString *clippedDate = [dateString substringToIndex:range.location];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ - %@    .", sport, clippedDate]];
}
@end
