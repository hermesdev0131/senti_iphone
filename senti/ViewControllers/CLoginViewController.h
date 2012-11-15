//
//  CLoginViewController.h
//  senti
//
//  Created by wonymini on 11/15/12.
//  Copyright (c) 2012 wonymini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLoginViewController : UIViewController {
    
}

@property (retain, nonatomic) IBOutlet UITextField *m_textEmail;
@property (retain, nonatomic) IBOutlet UITextField *m_textPass;
@property (retain, nonatomic) IBOutlet UIView *m_viewToolBar;

- (IBAction) onTouchGoogleBtn:(id)sender;
- (IBAction) onTouchFacebookbtn:(id)sender;
- (IBAction) onTouchNew:(id)sender;
- (IBAction) onTouchBackground:(id)sender;
- (IBAction) onTouchPrevBtn:(id)sender;
- (IBAction) onTouchNextBtn:(id)sender;
- (IBAction) onTouchDoneBtn:(id)sender;

@end
