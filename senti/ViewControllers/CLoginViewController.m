//
//  CLoginViewController.m
//  senti
//
//  Created by wonymini on 11/15/12.
//  Copyright (c) 2012 wonymini. All rights reserved.
//

#import "CLoginViewController.h"
#import "CRegisterViewController.h"

@interface CLoginViewController ()

@end

@implementation CLoginViewController

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
    
    _m_viewToolBar.frame = CGRectMake(0,
                                      self.view.frame.size.height,
                                      _m_viewToolBar.frame.size.width,
                                      _m_viewToolBar.frame.size.height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_textEmail release];
    [_m_textPass release];
    [_m_viewToolBar release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setM_textEmail:nil];
    [self setM_textPass:nil];
    [self setM_viewToolBar:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Keyboard Notification
- (void) keyboardWillShow: (NSNotification *)notification {
    [_m_viewToolBar setHidden: NO];
	UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	
	CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	
	[UIView beginAnimations:nil context: nil];
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationDuration:animationDuration];
	
	
	_m_viewToolBar.frame = CGRectMake(0,
								 self.view.frame.size.height - keyboardBounds.size.height - _m_viewToolBar.frame.size.height,
								 _m_viewToolBar.frame.size.width,
								 _m_viewToolBar.frame.size.height);
	[UIView commitAnimations];
}

- (void)keyboardWillHide: (NSNotification *)notification {
	UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
		
	[UIView beginAnimations:nil context: nil];
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationDuration:animationDuration];
	
	_m_viewToolBar.frame = CGRectMake(0,
								 self.view.frame.size.height,
								 _m_viewToolBar.frame.size.width,
								 _m_viewToolBar.frame.size.height);
	
	[UIView commitAnimations];
}

#pragma mark - Actions
// When touch on google button
- (IBAction)onTouchGoogleBtn:(id)sender {
}

// When touch on facebook button
- (IBAction)onTouchFacebookbtn:(id)sender {
}

// When touch "on new to senti?" button
- (IBAction)onTouchNew:(id)sender {
    CRegisterViewController *resgisterVC = nil;
    
    if ([CUtils isIphone5] == YES) {
        resgisterVC = [[CRegisterViewController alloc] initWithNibName:@"CRegisterViewController" bundle:nil];
    } else {
        resgisterVC = [[CRegisterViewController alloc] initWithNibName:@"CRegisterViewController_org" bundle:nil];
    }
    
    [self.navigationController pushViewController: resgisterVC animated: YES];
    
    [resgisterVC release];
}

// When touch on Background
- (IBAction)onTouchBackground:(id)sender {
    [_m_textEmail resignFirstResponder];
    [_m_textPass resignFirstResponder];
}
// When Touch on previous button on toolbar
- (IBAction)onTouchPrevBtn:(id)sender {
    [_m_textEmail becomeFirstResponder];
}
// When Touch on next button on toolbar
- (IBAction)onTouchNextBtn:(id)sender {
    [_m_textPass becomeFirstResponder];
}
// When Touch on done button on toolbar
- (IBAction)onTouchDoneBtn:(id)sender {
    [_m_textEmail resignFirstResponder];
    [_m_textPass resignFirstResponder];
    
    [self.navigationController dismissModalViewControllerAnimated: NO];
}

@end
