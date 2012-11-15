//
//  CRegisterViewController.m
//  senti
//
//  Created by wonymini on 11/15/12.
//  Copyright (c) 2012 wonymini. All rights reserved.
//

#import "CRegisterViewController.h"

@interface CRegisterViewController ()

@end

@implementation CRegisterViewController

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
    _m_viewToolbar.frame = CGRectMake(0,
                                      self.view.frame.size.height,
                                      _m_viewToolbar.frame.size.width,
                                      _m_viewToolbar.frame.size.height);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_textFirstName release];
    [_m_textLastName release];
    [_m_textEmail release];
    [_m_textPass release];
    [_m_viewToolbar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_textFirstName:nil];
    [self setM_textLastName:nil];
    [self setM_textEmail:nil];
    [self setM_textPass:nil];
    [self setM_viewToolbar:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Keyboard Notification
- (void) keyboardWillShow: (NSNotification *)notification {
    [_m_viewToolbar setHidden: NO];
	UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	
	CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	
	[UIView beginAnimations:nil context: nil];
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationDuration:animationDuration];
    
    if ([_m_textPass isFirstResponder]) {
        self.view.frame = CGRectMake(0,
                                     self.view.frame.origin.y - 60,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
    }
	_m_viewToolbar.frame = CGRectMake(0,
                                      self.view.frame.size.height - keyboardBounds.size.height - _m_viewToolbar.frame.size.height - self.view.frame.origin.y,
                                      _m_viewToolbar.frame.size.width,
                                      _m_viewToolbar.frame.size.height);
	[UIView commitAnimations];
}

- (void)keyboardWillHide: (NSNotification *)notification {
	UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
	[UIView beginAnimations:nil context: nil];
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationDuration:animationDuration];
	
	_m_viewToolbar.frame = CGRectMake(0,
                                      self.view.frame.size.height,
                                      _m_viewToolbar.frame.size.width,
                                      _m_viewToolbar.frame.size.height);
    
    self.view.frame = CGRectMake(0,
                                 0,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
	
	[UIView commitAnimations];
}



#pragma mark - Actions

// When touch on Google button
- (IBAction)onTouchGoogleBtn:(id)sender {
    
}

// When touch on Facebook button
- (IBAction)onTouchFacebookBtn:(id)sender {
    
}

// When touch on terms button
- (IBAction)onTouchTermsBtn:(id)sender {
    
}

// When touch on agree button
- (IBAction)onTouchAgreeBtn:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated: NO];
}

// When touch on previous button of toolbar
- (IBAction)onTouchPrevBtn:(id)sender {
    if ([_m_textPass isFirstResponder]) {
        [_m_textEmail becomeFirstResponder];
        self.view.frame = CGRectMake(0,
                                     self.view.frame.origin.y + 60,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
        _m_viewToolbar.frame = CGRectMake(0,
                                          _m_viewToolbar.frame.origin.y - 60,
                                          _m_viewToolbar.frame.size.width,
                                          _m_viewToolbar.frame.size.height);
    } else if ([_m_textEmail isFirstResponder]) {
        [_m_textLastName becomeFirstResponder];
    } else if ([_m_textLastName isFirstResponder]) {
        [_m_textFirstName becomeFirstResponder];
    }
}

// When touch on next button of toolbar
- (IBAction)onTouchNextBtn:(id)sender {
    if ([_m_textFirstName isFirstResponder]) {
        [_m_textLastName becomeFirstResponder];
    } else if ([_m_textLastName isFirstResponder]) {
        [_m_textEmail becomeFirstResponder];
    } else if ([_m_textEmail isFirstResponder]) {
        [_m_textPass becomeFirstResponder];
        if ([_m_textPass isFirstResponder]) {
            self.view.frame = CGRectMake(0,
                                         self.view.frame.origin.y - 60,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height);
            _m_viewToolbar.frame = CGRectMake(0,
                                              _m_viewToolbar.frame.origin.y + 60,
                                              _m_viewToolbar.frame.size.width,
                                              _m_viewToolbar.frame.size.height);
        }
    }
}

// When touch on previous button of toolbar
- (IBAction)onTouchDoneBtn:(id)sender {
    [_m_textFirstName resignFirstResponder];
    [_m_textLastName resignFirstResponder];
    [_m_textEmail resignFirstResponder];
    [_m_textPass resignFirstResponder];
}

// When touch on Background
- (IBAction)onTouchBackground:(id)sender {
    [_m_textFirstName resignFirstResponder];
    [_m_textLastName resignFirstResponder];
    [_m_textEmail resignFirstResponder];
    [_m_textPass resignFirstResponder];
}

@end
