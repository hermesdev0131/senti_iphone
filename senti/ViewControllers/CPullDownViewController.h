//
//  CPullDownViewController.h
//  senti
//
//  Created by wonymini on 11/15/12.
//  Copyright (c) 2012 wonymini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPullDownViewController : UIViewController {
    BOOL m_bExpand;
    
}

- (IBAction)onTouchSentiBtn:(id)sender;
- (IBAction)onTouchSentiLink:(id)sender;

@end
