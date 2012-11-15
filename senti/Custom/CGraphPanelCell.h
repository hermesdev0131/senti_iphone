//
//  CGraphPanelCell.h
//  BunkerGlam
//
//  Created by Wony Shin on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGraphPanelCell : UITableViewCell {
    
}

- (void) drawGraph : (NSInteger) nGraphType nIndex : (NSInteger) nIndex;

@property (retain, nonatomic) NSString *m_strImgURL;

@property (retain, nonatomic) IBOutlet UILabel *m_labelName;
@property (retain, nonatomic) IBOutlet UILabel *m_labelTime;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgPhoto;
@property (retain, nonatomic) IBOutlet UIView *m_viewLatestCheckins;
@property (retain, nonatomic) IBOutlet UIView *m_viewClearAll;
@property (retain, nonatomic) IBOutlet UIButton *m_btnClearAll;
@property (retain, nonatomic) IBOutlet UILabel *m_labelClearAll;


@end
