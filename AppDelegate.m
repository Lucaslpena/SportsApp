//
//  AppDelegate.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyC2UMGk8MTli8NFAo44aQCyCYOykRfgXM4"];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-Light" size:21.0], NSFontAttributeName, nil]];

    
    NSDictionary *user = [[SportsAppApi sharedInstance] loadUser];
    if ([user allKeys].count == 2) {
        [[SportsAppApi sharedInstance] loginUser:[user objectForKey:@"user"] Authentication:[user objectForKey:@"credential"] WithBlock:^(NSError *err, id result) {
            if ( (!err) && ([result isEqualToString:@"Correct Login"]) ){
 
                    SubFeedViewController *sfvc = (SubFeedViewController *)[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"SubFeedViewController"];
                    SideBarTableView *sbtv = (SideBarTableView *)[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"SideBarTableView"];
                    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:sfvc];
                    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:sbtv];
                    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
                    mainRevealController.rearViewRevealWidth = (self.window.frame.size.width * .80);
                    [sbtv setContainingView:mainRevealController];
                    self.window.rootViewController = mainRevealController;
            }
        }];
    }
    else
        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
