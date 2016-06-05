//
//  SideBarTableView.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "DrawerViewCell.h"

@interface SideBarTableView : UITableViewController <SWRevealViewControllerDelegate>

@property (nonatomic, strong) SWRevealViewController *containingView;

@end
