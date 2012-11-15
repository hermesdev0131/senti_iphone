//
//  CGuestCell.h
//  Bunker Glam
//
//  Created by Wony Shin on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGuestCell : UITableViewCell {
    
}

@property (retain, nonatomic) IBOutlet UILabel *m_labelName;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgLogo;

@property (retain, nonatomic) NSString *m_strImgURL;

- (void) refreshImage;

@end
