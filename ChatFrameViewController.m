//
//  ChatFrameViewController.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/18/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "ChatFrameViewController.h"

@interface ChatFrameViewController ()

@end

@implementation ChatFrameViewController {
    JSChatViewController* chatViewController;
    NSNumber *userId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar.topItem setTitle:@""];

    
    UIView *chatContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*.8, self.view.frame.size.height-65)];
    [chatContainer removeConstraints:chatContainer.constraints];
    chatViewController = [[JSChatViewController alloc] init];
    //[chatViewController setCurrentAd:self.pairUpAd];
    chatViewController.view.frame = chatContainer.frame;
    [chatViewController.tableView removeConstraints:chatViewController.tableView.constraints];
    [self addChildViewController:chatViewController];
    [chatContainer addSubview:chatViewController.view];
    [chatViewController didMoveToParentViewController:self];
    [self.view addSubview:chatContainer];
    [chatViewController setOtherId:userId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setOtherUser:(User *)user {
    userId = [user.attrs objectForKey:@"rowId"];
    if ([user.attrs objectForKey:@"fName"] == nil)
        [self.navigationItem setTitle:@"Chat"];
    else
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@ %@", [user.attrs objectForKey:@"fName"], [user.attrs objectForKey:@"lname"]]];
}
@end
