//
//  CRegisterViewController.h
//  senti
//
//  Created by wonymini on 11/15/12.
//  Copyright (c) 2012 wonymini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRegisterViewController : UIViewController {
    
}

@property (retain, nonatomic) IBOutlet UITextField *m_textFirstName;
@property (retain, nonatomic) IBOutlet UITextField *m_textLastName;
@property (retain, nonatomic) IBOutlet UITextField *m_textEmail;
@property (retain, nonatomic) IBOutlet UITextField *m_textPass;
@property (retain, nonatomic) IBOutlet UIView *m_viewToolbar;


- (IBAction) onTouchGoogleBtn:(id)sender;
- (IBAction) onTouchFacebookBtn:(id)sender;
- (IBAction) onTouchTermsBtn:(id)sender;
- (IBAction) onTouchAgreeBtn:(id)sender;
- (IBAction) onTouchPrevBtn:(id)sender;
- (IBAction) onTouchNextBtn:(id)sender;
- (IBAction) onTouchDoneBtn:(id)sender;
- (IBAction) onTouchBackground:(id)sender;



@end
