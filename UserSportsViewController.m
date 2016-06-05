//
//  UserSportsViewController.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/20/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "UserSportsViewController.h"

@interface UserSportsViewController ()

@end

@implementation UserSportsViewController {
    NSArray *sportArray;
    NSMutableArray *userSportArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userSportArray = [[NSMutableArray alloc] init];
    [[SportsAppApi sharedInstance] getSportsWithCompletionBlock:^(NSError *err, id result) {
        [[SportsAppApi sharedInstance] getSportsById:[[SportsAppApi sharedInstance].mainUser.attrs objectForKey:@"rowId"] WithCompletionBlock:^(NSError *err2, id result2) {
            for (NSDictionary *obj in result2) {
                [userSportArray addObject:[obj objectForKey:@"sport"]];
            }
            sportArray = [[NSArray alloc] initWithArray:result];
            [self.tableView reloadData];
        }];
    }];
}
-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
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
    return sportArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SportsTableViewCell";
    
    SportsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    NSString *cellLabel = [[sportArray objectAtIndex:indexPath.row] objectForKey:@"displayName"];
    [cell setLabel:cellLabel AndHeight:self.view.frame.size.width*.8];
    for (NSString *str in userSportArray) {
        if ([cellLabel isEqualToString:[[SportsAppApi sharedInstance]convertToDisplayNameWithCatagoryName:str]]) {
            [cell setSwitchEnabled];
        }
    }
    [cell setDelegate:self];
    return cell;
}
#pragma mark - Delegate Methods
-(void)sportDisplayName:(NSString *)sport WasAdded:(BOOL)trigger {
    if  (trigger)
        [userSportArray addObject:[[SportsAppApi sharedInstance]convertToCategoryNameWithDisplayName:sport]];
    else {
        [userSportArray removeObject:[[SportsAppApi sharedInstance]convertToCategoryNameWithDisplayName:sport]];
    }
    [self updateSports];
}
-(void)updateSports {
    [[SportsAppApi sharedInstance] setSports:userSportArray ById:[[SportsAppApi sharedInstance].mainUser.attrs objectForKey:@"rowId"] WithCompletionBlock:^(NSError *err, id result) {
        if( (err) || ([result isEqualToString:@"406"]) ){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Saving Sports" message:@"Check connection and try again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

@end
