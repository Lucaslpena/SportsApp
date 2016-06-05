//
//  UserListingsTableView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/15/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "UserListingsTableView.h"

@interface UserListingsTableView ()

@end

@implementation UserListingsTableView {
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
    [[SportsAppApi sharedInstance] getListingsByCreatorId:[[SportsAppApi sharedInstance].mainUser.attrs objectForKey:@"rowId"] WithCompletionBlock:^(NSError * err, id result) {
        listings = [[NSArray alloc] initWithArray:result];
        [self.tableView reloadData];
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationItem setTitle:@"My Listings"];
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
    return listings.count; //listings.count;
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
    [self performSegueWithIdentifier:@"SellingListings" sender:self];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SellingListingViewController *slvc = [[SellingListingViewController alloc] init];
    slvc = [segue destinationViewController];
    [slvc setListing:segueData];
}
@end