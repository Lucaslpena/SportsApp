//
//  UserPurchasesTableView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/15/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "UserPurchasesTableView.h"

@interface UserPurchasesTableView ()

@end

@implementation UserPurchasesTableView {
    NSArray *listings;
    Listing *segueData;
    BOOL segueForward;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
     [self.tableView registerNib:[UINib nibWithNibName:@"AccountListingsCell" bundle:nil] forCellReuseIdentifier:@"AccountListingsCell"];
    [self.tableView setDelaysContentTouches:YES];
    [self.tableView setCanCancelContentTouches:YES];
    [[SportsAppApi sharedInstance] getListingsByBuyerId:[[SportsAppApi sharedInstance].mainUser.attrs objectForKey:@"rowId"] WithCompletionBlock:^(NSError * err, id result) {
        listings = [[NSArray alloc] initWithArray:result];
        [self.tableView reloadData];
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationItem setTitle:@"My Purchases"];
    segueForward = false;
}
-(void)viewWillDisappear:(BOOL)animated {
    if (!segueForward) {
        [self.navigationController.navigationBar setHidden:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listings.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AccountListingsCell";
    AccountListingsCell *alCell = (AccountListingsCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [alCell resizeViewWidth:self.tableView.frame.size.width*.8];
    [alCell setData:[listings objectAtIndex:indexPath.row]];
    [alCell setDelegate:self];
    return alCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}
#pragma mark - Delegate methods
-(void)listingWasTouched:(Listing *)payload {
    segueForward = true;
    segueData = payload;
    [self performSegueWithIdentifier:@"PurchasedListing" sender:self];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PurchasedListingViewController *plvc = [[PurchasedListingViewController alloc] init];
    plvc = [segue destinationViewController];
    [plvc setListing:segueData];
}

@end
