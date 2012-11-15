//
//  CGuestCell.m
//  Bunker Glam
//
//  Created by Wony Shin on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CGuestCell.h"
#import "DataKeeper.h"

@implementation CGuestCell
@synthesize m_labelName;
@synthesize m_imgLogo;
@synthesize m_strImgURL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [m_labelName release];
    [m_imgLogo release];
    [m_strImgURL release];
    [super dealloc];
}

#pragma mark - Set Image to cell

- (void) refreshImage {
    [NSThread detachNewThreadSelector:@selector(getImage) toTarget:self withObject:nil];
}

- (void) getImage {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    for (;;){
    
        UIImage *image = [dataKeeper getLocalImage: m_strImgURL];
        
        if (image != nil) {
            [m_imgLogo setImage: image];
            break;
        } else {
            sleep(1);
        }
    }
    
    [autoreleasePool release];
}
@end
