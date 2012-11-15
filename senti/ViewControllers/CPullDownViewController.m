//
//  CPullDownViewController.m
//  senti
//
//  Created by wonymini on 11/15/12.
//  Copyright (c) 2012 wonymini. All rights reserved.
//

#import "CPullDownViewController.h"

@interface CPullDownViewController ()

@end

@implementation CPullDownViewController

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
    m_bExpand = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
- (IBAction)onTouchSentiBtn:(id)sender {
    UIViewAnimationCurve animationCurve = 0.3;
	NSTimeInterval animationDuration = 0.6;
    
	[UIView beginAnimations:nil context: nil];
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationDuration:animationDuration];
    
    if (m_bExpand == NO) {
		self.view.frame = CGRectMake(0, 0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
        m_bExpand = YES;
    } else {
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y - self.view.frame.size.height + 70,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
        m_bExpand = NO;
    }
    
	[UIView commitAnimations];
    
    NSLog(@"Senti Button!");
}

- (IBAction)onTouchSentiLink:(id)sender {
    
}
@end
