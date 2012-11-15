//
//  CAppDelegate.h
//  senti
//
//  Created by wonymini on 11/14/12.
//  Copyright (c) 2012 wonymini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDTabBarController.h"
#import "CPullDownViewController.h"

@interface CAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) CPullDownViewController *m_pulldownVC;

@end
