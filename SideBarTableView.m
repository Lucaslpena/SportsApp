//
//  SideBarTableView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "SideBarTableView.h"

@interface SideBarTableView ()

@end

@implementation SideBarTableView {
    NSArray *sectionTitles;
    NSMutableDictionary *cellContents;
}

/*  Note all segue views are at their normal frame [self.view.frame.size.width]
 *  Therefore all displaying views are actually uiviews that are added with proper
 *  widths to exactly fit the drawerView. All views are dynamic and fit for all screen
 *  sizes. Delegate methods are used to connect interaction between view and controller.
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self.navigationController.navigationBar setHidden:YES];
    [self.containingView setDelegate:self];
    [self.tableView setBounces:NO];
    sectionTitles = [NSArray arrayWithObjects:@"Account", @"Bench", @"Preferences", nil];
    NSArray* account = [NSArray arrayWithObjects:@"Me", @"Purchases", @"Listings", nil];
    NSArray *bench = [NSArray arrayWithObjects:@"Friends", @"Reserves", nil];
    NSArray *preferences = [NSArray arrayWithObjects:@"My Sports", @"Notifications", nil];
    cellContents = [NSMutableDictionary dictionaryWithObjectsAndKeys:account, [sectionTitles objectAtIndex:0], bench, [sectionTitles objectAtIndex:1], preferences, [sectionTitles objectAtIndex:2], nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)setupNavigationBar {
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar.topItem setTitle:@""];
    [self.view setBackgroundColor:[UIColor colorWithRed:212/255.0f green:221/255.0f blue:228/255.0f alpha:1.0f]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:212/255.0f green:221/255.0f blue:228/255.0f alpha:1.0f]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0]};

}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionTitles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = [cellContents objectForKey:[sectionTitles objectAtIndex:section]];
    return sectionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DrawerViewCell";
    DrawerViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    NSString *section = [sectionTitles objectAtIndex:indexPath.section];
    NSArray *dataArray = [NSArray arrayWithArray:[cellContents objectForKey:section]];
    NSString *cellLabel = [dataArray objectAtIndex:indexPath.row];
    [cell.cellLabel setText:cellLabel];
    [cell setCellImageIcon:cellLabel];
    [cell setDisclosureIndicatorAt:self.view.frame.size.width*.8];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    Uncomment the following code for variable drawer sizes
//    if changing size depending on different cell interactions... that goes BELOW
//    self.containingView.rearViewRevealWidth = 300;
//    /// the below calls trigger animations
//    [self.containingView revealToggleAnimated:NO];
//    [self.containingView revealToggleAnimated:NO];
    
    NSArray *sectionArray = [cellContents objectForKey:[sectionTitles objectAtIndex:indexPath.section]];
    NSString *cellTitle = [sectionArray objectAtIndex:indexPath.row];
    if ([cellTitle isEqualToString:@"Me"]) {
        [self performSegueWithIdentifier:@"UserProfilePage" sender:self];
    }
    else if ([cellTitle isEqualToString:@"Purchases"]) {
        [self performSegueWithIdentifier:@"PurchasesView" sender:self];
    }
    else if ([cellTitle isEqualToString:@"Listings"]) {
        [self performSegueWithIdentifier:@"ListingsView" sender:self];
    }
    else if ([cellTitle isEqualToString:@"Friends"]) {
        [self performSegueWithIdentifier:@"FriendsView" sender:self];
    }
    else if ([cellTitle isEqualToString:@"Reserves"]) {
        [self performSegueWithIdentifier:@"ReservesView" sender:self];
    }
    else if ([cellTitle isEqualToString:@"My Sports"]) {
        [self performSegueWithIdentifier:@"UserSportsView" sender:self];
    }
    else if ([cellTitle isEqualToString:@"Notifications"]) {
        [self performSegueWithIdentifier:@"Notifications" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat point = 80;
    if (self.view.frame.size.height == 480) {
        point = 60;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, (point-45), 200, 40)];
    [headerLabel setText:[sectionTitles objectAtIndex:section]];
    [headerLabel setTextColor:[UIColor darkGrayColor]];
    [headerView setBackgroundColor:[UIColor colorWithRed:212/255.0f green:221/255.0f blue:228/255.0f alpha:1.0f]];
    [headerView addSubview:headerLabel];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.view.frame.size.height == 480) {
        return 60;
    }
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - SWRevealViewController Delegates
-(void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
