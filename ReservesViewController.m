//
//  ReservesViewController.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/20/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "ReservesViewController.h"


@interface ReservesViewController ()

@end

@implementation ReservesViewController {
    NSArray *userIds;
    User *segueData;
    BOOL segueForward;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserTableViewCell"];
    [self.tableView setDelaysContentTouches:YES];
    [self.tableView setCanCancelContentTouches:YES];
    [[SportsAppApi sharedInstance]getFriendsById:[[SportsAppApi sharedInstance].mainUser.attrs objectForKey:@"rowId"] WithCompletionBlock:^(NSError *err, id result) {
        userIds = result;
        [self.tableView reloadData];
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationItem setTitle:@"My Reserves"];
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
    return userIds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserTableViewCell";
    UserTableViewCell *utvCell = (UserTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [utvCell resizeViewWidth:self.tableView.frame.size.width*.8];
    [utvCell setData:[userIds objectAtIndex:indexPath.row]];
    [utvCell setDelegate:self];
    return utvCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
#pragma mark - Delegate methods
-(void)cellWasTouched:(User *)payload{
    segueForward = true;
    segueData = payload;
    [self performSegueWithIdentifier:@"ChatSegue" sender:self];
}
@end