//
//  SubFeedViewController.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "SubFeedViewController.h"

@interface SubFeedViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@end

@implementation SubFeedViewController {
    NSString *segueCategory;
    NSMutableData *responseData;
    NSArray *parsedListingResponse;
    NSMutableArray *sectionTitlesArray;
    UIActivityIndicatorView *spinner;
    PopupFrameView *ppv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self drawerSetup];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f];
    self.refreshControl.tintColor = [UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f];
    [self.refreshControl addTarget:self
                            action:@selector(refreshData)
                  forControlEvents:UIControlEventValueChanged];

    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height/2-60)];
    [self.view addSubview:spinner];
    [self.view sendSubviewToBack:self.tableView];
    [spinner startAnimating];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FeedViewCell" bundle:nil] forCellReuseIdentifier:@"FeedViewCell"];
    [self.tableView setDelaysContentTouches:YES];
    [self.tableView setCanCancelContentTouches:YES];
    [self refreshData];
}
-(void)refreshData {
    [[SportsAppApi sharedInstance] getFeedListingsWithCompletionBlock:^(NSError *err, id result) {
        if (!err) {
            parsedListingResponse = [[NSArray alloc] initWithArray:[result removeEmptyCategories]];
            [self createSectionTitles];
            [spinner stopAnimating];
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) setupNavigationBar {
    [self.navigationController.navigationBar.topItem setTitle:@""];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,50, self.navigationController.navigationBar.frame.size.height - 10)];
    [logo setCenter:CGPointMake(self.view.window.frame.size.width/2, self.navigationController.navigationBar.frame.size.height/2)];
    [logo setImage:[UIImage imageNamed:@"WHITE_logo.png"]];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    [logo setClipsToBounds:YES];
    self.navigationItem.titleView = logo;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(generateCreate)];
//    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(viewChangeForId:)];
    NSArray *barButtonItems = @[addButton];
    self.navigationItem.rightBarButtonItems = barButtonItems;

//    //BELOW IS NEEDED FOR PROPER CENTERING OF TITLEIMAGE
//    NSMutableArray *leftButtons = [[NSMutableArray alloc] initWithArray:self.navigationItem.leftBarButtonItems];
////    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(viewChangeForId:)];
////    [spaceButton setEnabled:NO];
////    [spaceButton setTintColor:[UIColor clearColor]];
//    [leftButtons addObject:spaceButton];
//    self.navigationItem.leftBarButtonItems = leftButtons;
  
    UIFont * font = [UIFont fontWithName:kFontAwesomeFamilyName size:23];
    NSDictionary * attributes = @{NSFontAttributeName: font};
    [self.revealButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.revealButtonItem setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-bars"]];
}
- (void)drawerSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        SWRevealViewController *revealController = self.revealViewController;
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    }
}
#pragma mark - API preconfiguring for TableView
-(void)createSectionTitles {
    sectionTitlesArray = [[NSMutableArray alloc] init];
    for (NSDictionary *listingTypes in parsedListingResponse)
    {
        [sectionTitlesArray addObject:[[SportsAppApi sharedInstance] convertToDisplayNameWithCatagoryName:[listingTypes objectForKey:@"categoryName"]]];
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionTitlesArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderFeedView *hfv = [[HeaderFeedView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [hfv setDelegate:self];
    [hfv setPressPayload:[sectionTitlesArray objectAtIndex:section]];
    [hfv setLabelText:[sectionTitlesArray objectAtIndex:section]];
    [hfv setButtonText:[parsedListingResponse getListingCountByCatagory:[[SportsAppApi sharedInstance] convertToCategoryNameWithDisplayName:[sectionTitlesArray objectAtIndex:section]]]];
    return hfv;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FeedViewCell";
    FeedViewCell *fvCell = (FeedViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [fvCell resizeViewWidth:self.tableView.frame.size.width];
    
    if ([[sectionTitlesArray objectAtIndex:indexPath.section] isEqualToString:@"Expiring Soon"] || [[sectionTitlesArray objectAtIndex:indexPath.section] isEqualToString:@"Friends and Reserves"]) {
        NSArray *listingArray = [parsedListingResponse getListingsByCatagory:[sectionTitlesArray objectAtIndex:indexPath.section]];
        [fvCell initForSubFeeds:listingArray];
    } else {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[[[SportsAppApi sharedInstance] convertToCategoryNameWithDisplayName:[sectionTitlesArray objectAtIndex:indexPath.section]]] forKeys:@[@"categoryName"]];
        [fvCell initforSport:dict];
    }
    [fvCell setDelegate:self];
    return fvCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[SportsAppApi sharedInstance] checkIfValidDisplayName:sectionTitlesArray[indexPath.section]])
        return (self.view.frame.size.width / 2);
    else
        return [FeedViewCell returnHeightForListingsWithScreenWidth:self.view.frame.size.width];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Delegate Methods
-(void)listingTouchPayload:(Listing *)payload {
    [self generateView:payload];
}
-(void)sectionButtonPressed:(NSString *)payload {
    [self viewChangeForId:[[SportsAppApi sharedInstance] convertToCategoryNameWithDisplayName:payload]];
}
-(void)categoryTouchPayload:(NSString *)payload {
    [self viewChangeForId:payload];
}
#pragma mark - Popup
-(void)generateCreate {
    for (UIBarButtonItem* button in self.navigationItem.rightBarButtonItems) {
        button.enabled = NO;
    }
    CGFloat indentation = 5;
    ppv = [[PopupFrameView alloc] initWithFrame:CGRectMake(indentation, indentation, self.view.frame.size.width-(indentation*2), self.view.frame.size.height-(indentation*2))];
    [ppv setDelegate:self];
    [ppv setParentController:self];
    [ppv loadSubViewsForCreateScroll];
    [self.view addSubview:ppv];
    [ppv animateOpen];
}
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
        ppv = nil;
        self.tableView.scrollEnabled = YES;
        self.tableView.alwaysBounceVertical = YES;
        for (UIBarButtonItem* button in self.navigationItem.rightBarButtonItems) {
            button.enabled = YES;
        }
        [self refreshData];
    }
}
#pragma mark - Segue
-(void)viewChangeForId:(NSString *)category{
    if ([category isKindOfClass:[UIBarButtonItem class]]) {
        category = @"Search";
    }
    segueCategory = [[NSString alloc] initWithString:category];
    [self performSegueWithIdentifier:@"listView" sender:self];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ListingFeedViewController *lfvc = [[ListingFeedViewController alloc] init];
    lfvc = [segue destinationViewController];
    if (segueCategory) {
        [lfvc initWithCategory:segueCategory];
        segueCategory = nil;
    }
}
@end
