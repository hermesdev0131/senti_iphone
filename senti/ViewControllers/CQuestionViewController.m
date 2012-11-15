//
//  CQuestionViewController.m
//  senti
//
//  Created by wonymini on 11/15/12.
//  Copyright (c) 2012 wonymini. All rights reserved.
//

#import "CQuestionViewController.h"
#import "CQuizViewController.h"
#import "CAppDelegate.h"


@interface CQuestionViewController ()

@end

@implementation CQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    NSLog(@"appear");
    // Begin Quiz Screen
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    if (dataKeeper.m_bQuizStart == YES) {
        CQuizViewController *quizVC = nil;
        quizVC = [[CQuizViewController alloc] init];
        
        if ([CUtils isIphone5]) {
            quizVC = [[CQuizViewController alloc] initWithNibName:@"CQuizViewController" bundle:nil];
        } else {
            quizVC = [[CQuizViewController alloc] initWithNibName:@"CQuizViewController_org" bundle:nil];
        }
                
        [self presentModalViewController:quizVC animated:NO];
        [quizVC release];
    } else {
        CAppDelegate *appDelegate = (CAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        VDTabBarController *tabBarVC = (VDTabBarController *)appDelegate.tabBarController;
        
        [tabBarVC selectTab: 1];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"disappear");
}

- (void) viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
