//
//  CAppDelegate.m
//  senti
//
//  Created by wonymini on 11/14/12.
//  Copyright (c) 2012 wonymini. All rights reserved.
//

#import "CAppDelegate.h"

#import "CLoginViewController.h"
#import "CQuestionViewController.h"
#import "CUpdatesViewController.h"
#import "CFriendsViewController.h"
#import "CProfileViewController.h"
#import "CSettingsViewController.h"

@implementation CAppDelegate

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [_m_pulldownVC release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    UIViewController *loginVC = nil;
    UIViewController *questionVC = nil;
    UIViewController *updatesVC = nil;
    UIViewController *friendsVC = nil;
    UIViewController *profileVC = nil;
    UIViewController *settingsVC = nil;
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    dataKeeper.m_bQuizStart = YES;

    

    
    // Override point for customization after application launch.
    if ([CUtils isIphone5] == YES) {
        _m_pulldownVC = [[CPullDownViewController alloc] initWithNibName:@"CPullDownViewController" bundle:nil];
        
        loginVC = [[[CLoginViewController alloc] initWithNibName:@"CLoginViewController" bundle:nil] autorelease];
        questionVC = [[[CQuestionViewController alloc] initWithNibName:@"CQuestionViewController" bundle:nil] autorelease];
        updatesVC = [[[CUpdatesViewController alloc] initWithNibName:@"CUpdatesViewController" bundle:nil] autorelease];
        friendsVC = [[[CFriendsViewController alloc] initWithNibName:@"CFriendsViewController" bundle:nil] autorelease];
        profileVC = [[[CProfileViewController alloc] initWithNibName:@"CProfileViewController" bundle:nil] autorelease];
        settingsVC = [[[CSettingsViewController alloc] initWithNibName:@"CSettingsViewController" bundle:nil] autorelease];
    } else {
        _m_pulldownVC = [[CPullDownViewController alloc] initWithNibName:@"CPullDownViewController_org" bundle:nil];
        
        loginVC = [[[CLoginViewController alloc] initWithNibName:@"CLoginViewController_org" bundle:nil] autorelease];
        questionVC = [[[CQuestionViewController alloc] initWithNibName:@"CQuestionViewController" bundle:nil] autorelease];
        
        updatesVC = [[[CUpdatesViewController alloc] initWithNibName:@"CUpdatesViewController_org" bundle:nil] autorelease];
        friendsVC = [[[CFriendsViewController alloc] initWithNibName:@"CFriendsViewController" bundle:nil] autorelease];
        profileVC = [[[CProfileViewController alloc] initWithNibName:@"CProfileViewController" bundle:nil] autorelease];
        settingsVC = [[[CSettingsViewController alloc] initWithNibName:@"CSettingsViewController" bundle:nil] autorelease];
    }

    self.tabBarController = [[[VDTabBarController alloc] init] autorelease];

    self.tabBarController.viewControllers = @[questionVC, updatesVC, friendsVC, profileVC, settingsVC];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    _m_pulldownVC.view.frame = CGRectMake(_m_pulldownVC.view.frame.origin.x,
                                       _m_pulldownVC.view.frame.origin.y - _m_pulldownVC.view.frame.size.height + 70, _m_pulldownVC.view.frame.size.width, _m_pulldownVC.view.frame.size.height);
    [self.window addSubview: _m_pulldownVC.view];

    
    UINavigationController *navLoginVC = [[[UINavigationController alloc] initWithRootViewController: loginVC] autorelease];
    
    [navLoginVC setNavigationBarHidden: YES];
    
    [self.tabBarController presentModalViewController:navLoginVC animated:NO];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
