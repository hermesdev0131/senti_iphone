//
//  CQuizViewController.m
//  senti
//
//  Created by wonymini on 11/15/12.
//  Copyright (c) 2012 wonymini. All rights reserved.
//

#import "CQuizViewController.h"


@interface CQuizViewController ()

@end

@implementation CQuizViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)onTouchSkipBtn:(id)sender {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    dataKeeper.m_bQuizStart = NO;
    
    
    [self dismissModalViewControllerAnimated: NO];
}
@end
