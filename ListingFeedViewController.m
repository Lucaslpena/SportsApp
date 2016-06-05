//
//  ListingFeedViewController.m
//  SportsApp
//
//  Created by Lucas L. Pena on 12/11/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "ListingFeedViewController.h"

@interface ListingFeedViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ListingFeedViewController {
    NSString *listingCategory;
    IBOutlet UIButton *searchButton;
    IBOutlet UITextField *searchField;
    PopupFrameView *ppv;
    UIActivityIndicatorView *spinner;
    NSDictionary *listingsDictionary;
    UIRefreshControl *refreshControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f]];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height/2-60)];
    [self.view addSubview:spinner];
    [self.view sendSubviewToBack:self.tableView];
    [spinner startAnimating];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f];
    refreshControl.tintColor = [UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f];
    [refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f]];
    [searchButton.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [searchButton setTitle: [NSString fontAwesomeIconStringForIconIdentifier:@"fa-search"] forState:UIControlStateNormal];
    [self.tableView registerNib:[UINib nibWithNibName:@"ListingHorizontalViewCell" bundle:nil] forCellReuseIdentifier:@"ListingHorizontalViewCell"];
    [self.tableView setDelaysContentTouches:YES];
    [self.tableView setCanCancelContentTouches:YES];
    [searchField setDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewDidAppear:(BOOL)animated {
    [self reloadData];
}
-(void)initWithCategory:(NSString *)category {
    listingCategory = [[NSString alloc] initWithString:category];
    //[self reloadData];
    [self.navigationItem setTitle:[[SportsAppApi sharedInstance] convertToDisplayNameWithCatagoryName:category]];
}
-(void)reloadData {
    [[SportsAppApi sharedInstance] getListingsByCategory:listingCategory WithCompletionBlock:^(NSError *err, id result) {
        listingsDictionary = [[NSDictionary alloc] initWithDictionary:[[result objectForKey:@"listings"] sortListingsByDate]];
        [searchField setText:@""];
        [spinner stopAnimating];
        [refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *dayArray = [listingsDictionary objectForKey:@"dayArray"];
    return dayArray.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderFeedView *hfv = [[HeaderFeedView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    NSArray *dayArray = [listingsDictionary objectForKey:@"dayArray"];
    [hfv setLabelText:[dayArray objectAtIndex:section]];
    [hfv setButtonHidden];
    return hfv;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *listingArrayPerDay = [listingsDictionary objectForKey:@"listingArrayPerDay"];
    NSArray *listingsOnToday = [listingArrayPerDay objectAtIndex:section];
    return listingsOnToday.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ListingHorizontalViewCell";
    ListingHorizontalViewCell *lhCell = (ListingHorizontalViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *listingArrayPerDay = [listingsDictionary objectForKey:@"listingArrayPerDay"];
    NSArray *listingsOnToday = [listingArrayPerDay objectAtIndex:indexPath.section];
    Listing *obj = [listingsOnToday objectAtIndex:indexPath.row];
    [lhCell setData:obj];
    [lhCell setDelegate:self];
    return lhCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Delegate Methods
-(void)listingWasTouched:(Listing *)payload {
    [self generateView:payload];
}
#pragma mark - Popup
-(void)generateView:(Listing *)obj {
    CGFloat indentation = 5;
     ppv = [[PopupFrameView alloc] initWithFrame:CGRectMake(indentation, indentation, self.view.frame.size.width-(indentation*2), self.view.frame.size.height-(indentation*2))];
    [ppv setDelegate:self];
    [ppv setParentController:self];
    [ppv loadSubViewsForDetailView:obj];
    [self.view addSubview:ppv];
    [ppv animateOpen];
}
-(void)popupFrameDidOpen:(bool)open {
    if (open) {
        self.tableView.scrollEnabled = NO;
        self.tableView.alwaysBounceVertical = NO;
    } else {
        [ppv removeFromSuperview];
        self.tableView.scrollEnabled = YES;
        self.tableView.alwaysBounceVertical = YES;
    }
}
#pragma mark - Search Button
- (IBAction)searchTrigger:(id)sender {
    [self.tableView setHidden:YES];
    [spinner startAnimating];
    [[SportsAppApi sharedInstance] searchListingsByCategory:listingCategory WithFilter:searchField.text WithCompletionBlock:^(NSError *err, id result) {
        listingsDictionary = [[NSDictionary alloc] initWithDictionary:[[result objectForKey:@"listings"] sortListingsByDate]];
        [spinner stopAnimating];
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    }];
}
//Keyboard Dismiss
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textfield
{
    [textfield resignFirstResponder];
    [self searchTrigger:self];
    return YES;
}
@end
