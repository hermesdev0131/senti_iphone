//
//  CGraphPanelCell.m
//  BunkerGlam
//
//  Created by Wony Shin on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CGraphPanelCell.h"
#import "PCLineChartView.h"
#import "DataKeeper.h"
#import "CUtils.h"

@implementation CGraphPanelCell
@synthesize m_labelName;
@synthesize m_labelTime;
@synthesize m_imgPhoto;
@synthesize m_viewLatestCheckins;
@synthesize m_viewClearAll;
@synthesize m_btnClearAll;
@synthesize m_labelClearAll;
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
    [m_labelTime release];
    [m_imgPhoto release];
    [m_strImgURL release];
    [m_viewLatestCheckins release];
    [m_btnClearAll release];
    [m_viewClearAll release];
    [m_labelClearAll release];
    [super dealloc];
}

#pragma mark - Internal Functions

- (void) drawGraph : (NSInteger) nGraphType nIndex : (NSInteger) nIndex {
    // Create Graph View
    
    PCLineChartView *lineChartView = nil;
    
    if (nGraphType < 2) {
        lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(0, 10, [self bounds].size.width, [self bounds].size.height - 10)];
        
        [lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
    }
    
    // Get Data Model Manager Handler
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];

    // X-Axis Titles Array
    NSMutableArray *titles = nil;
    NSInteger nMaxVal = 0;
    
    // Create Date Formatter
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // if it's age graph...
    if (nGraphType == 0) {
        // Report Dictionary
        NSMutableDictionary *dictReport = [[NSMutableDictionary alloc] init];
        
       // Titles - Array
       titles  = [NSMutableArray arrayWithObjects:@"18~22", @"23~26", @"27~30", @"31~35", @"36~40", @"40+", nil];
        
        // Build Data structures for drawing graph
        for (NSInteger nIndex = 0; nIndex < [dataKeeper.m_arrayCheckins count]; nIndex++) {
            
            // Get a Checkin Item for nIndex
            NSDictionary *dictCheckin = [dataKeeper.m_arrayCheckins objectAtIndex: nIndex];
            
            // Get gender of Checkin Guest
            NSString *strGender = [dictCheckin objectForKey:@"gender"];
            
            if ([strGender isEqualToString: @"<null>"]) {
                continue;
            }
            NSLog(@"gender = %@", strGender);
            NSInteger nAgeTerm;
            NSInteger nAge = [CUtils getAge: (NSString *)[dictCheckin objectForKey:@"birthday"]];
            
            if (nAge >= 18 && nAge <= 22) {
                nAgeTerm = 0;
            } else if (nAge >= 23 && nAge <= 26) {
                nAgeTerm = 1;
            } else if (nAge >= 27 && nAge <= 30) {
                nAgeTerm = 2;
            } else if (nAge >= 31 && nAge <= 35) {
                nAgeTerm = 3;
            } else if (nAge >= 36 && nAge <= 40) {
                nAgeTerm = 4;
            } else if (nAge > 40) {
                nAgeTerm = 5;
            } else {
                continue;
            }
            
            NSMutableArray *arrayData = [dictReport objectForKey:strGender];
            
            if (arrayData == nil) {
                NSNumber *numberZero = [NSNumber numberWithInt: 0];
                arrayData = [[[NSMutableArray alloc] initWithObjects:numberZero, numberZero, numberZero, numberZero, numberZero, numberZero, nil] autorelease];
            }
            
            NSNumber *numberVal = [arrayData objectAtIndex: nAgeTerm];
    
            if (numberVal == nil) {
                numberVal = [NSNumber numberWithInt: 0];
            }
            
            NSInteger nVal = [numberVal integerValue];
            
            NSNumber *newVal = [NSNumber numberWithInt: nVal + 1];
            
            if (nVal + 1 > nMaxVal) {
                nMaxVal = nVal + 1;
            }
            
            [arrayData replaceObjectAtIndex:nAgeTerm withObject:newVal];
            
            [dictReport setObject:arrayData forKey:strGender];
        }
        
        if (nMaxVal < 10) {
            nMaxVal = 10;
        }
        
		lineChartView.minValue = 0;
		lineChartView.maxValue = nMaxVal;
        lineChartView.interval = nMaxVal / 10;
        
		[self addSubview:lineChartView];
		        
        NSMutableArray *components = [NSMutableArray array];
        
		for (int i = 0; i < [[dictReport allKeys] count]; i++)
		{
            NSString *strKey = [[dictReport allKeys] objectAtIndex: i];
            NSArray *arrayData = [dictReport objectForKey: strKey];
			PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
		//	[component setTitle: strKey];
			[component setPoints: arrayData];
			[component setShouldLabelValues:NO];
			
			if (i==0)
			{
				[component setColour:PCColorRed];
			}
			else if (i==1)
			{
				[component setColour:PCColorBlue];
			}			
			[components addObject:component];
		}
		[lineChartView setComponents:components];
		[lineChartView setXLabels: titles];
    } else if (nGraphType == 1) {
    // Draw Checkin graph
        
        NSInteger nIndex;
        NSInteger nMinIndex = 0;
        NSInteger nMaxIndex = 0;
        
        NSInteger nTimeInterval = 30;
        
        // Get first time and last time
        for (nIndex = 0; nIndex < [dataKeeper.m_arrayCheckins count]; nIndex++) {
            // Get a Checkin Item for nIndex
            NSDictionary *dictCheckin = [dataKeeper.m_arrayCheckins objectAtIndex: nIndex];
            NSDictionary *dictMin = [dataKeeper.m_arrayCheckins objectAtIndex: nMinIndex];
            NSDictionary *dictMax = [dataKeeper.m_arrayCheckins objectAtIndex: nMaxIndex];
            
            NSString *strDate = [dictCheckin objectForKey:@"date"];
            NSString *strMinDate = [dictMin objectForKey:@"date"];
            NSString *strMaxDate = [dictMax objectForKey:@"date"];
            
            NSDate *convertedDate = [df dateFromString:strDate];
            NSDate *convertedMinDate = [df dateFromString: strMinDate];
            NSDate *convertedMaxDate = [df dateFromString: strMaxDate];

            if ([convertedDate compare: convertedMinDate] == NSOrderedAscending) {
                nMinIndex = nIndex;
            }
            
            if ([convertedDate compare: convertedMaxDate] == NSOrderedDescending) {
                nMaxIndex = nIndex;
            }
        }
        
        if ([dataKeeper.m_arrayCheckins count] <= 0) {
            return;
        }
        
        NSDictionary *dictMin = [dataKeeper.m_arrayCheckins objectAtIndex: nMinIndex];
        NSDictionary *dictMax = [dataKeeper.m_arrayCheckins objectAtIndex: nMaxIndex];
        
        NSString *strMinDate = [dictMin objectForKey:@"date"];
        NSString *strMaxDate = [dictMax objectForKey:@"date"];

        
        NSDate *dateMin =  [df dateFromString: strMinDate];
        NSDate *dateMax = [df dateFromString: strMaxDate];
        

        
        NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
        
        NSDateComponents *dateMinComponents =
        [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:dateMin];
        
        NSInteger minute = [dateMinComponents minute];
        NSInteger minInterval = minute % 30;
        
        dateMin = [NSDate dateWithTimeInterval:-minInterval * 60 sinceDate:dateMin];
        
        NSDateComponents *dateComponents = [calendar components:NSMinuteCalendarUnit fromDate:dateMin toDate:dateMax options:0];
        
        // Get Duration Minutes
        NSInteger nDiffMinutes = dateComponents.minute;

        NSInteger nCount = nDiffMinutes / nTimeInterval;
        
//        if (nDiffMinutes % 15 > 0) {
            nCount++;
//        }
        
        titles = [[[NSMutableArray alloc] init] autorelease];
        
        for (nIndex = 0; nIndex < nCount; nIndex++) {
            NSDate *curDate = [NSDate dateWithTimeInterval:nIndex * 30 * 60 sinceDate:dateMin];
            NSDateComponents *dateCom = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:curDate];
            
            
            if (nIndex == 0 || nIndex == nCount - 1) {
                [titles addObject: [NSString stringWithFormat:@"%d-%d-%d %d:%d", dateCom.year, dateCom.month, dateCom.day, dateCom.hour, dateCom.minute]];
            } else {
                [titles addObject: [NSString stringWithFormat:@"%d:%d", dateCom.hour, dateCom.minute]];
            }
        }
        
        NSMutableArray *arrayCheckins = [[NSMutableArray alloc] init];
        
        for (nIndex = 0; nIndex < nCount; nIndex++) {
            [arrayCheckins addObject: [NSNumber numberWithInteger: 0]];
        }
        
        for (nIndex = 0; nIndex < [dataKeeper.m_arrayCheckins count]; nIndex++) {
            NSDictionary *dict = [dataKeeper.m_arrayCheckins objectAtIndex: nIndex];
            NSString *strDate = [dict objectForKey:@"date"];
            NSDate *date = [df dateFromString: strDate];
            
            dateComponents = [calendar components:NSMinuteCalendarUnit fromDate:dateMin toDate:date options:0];
            
            NSInteger nDiffMinutes = dateComponents.minute;
            
            NSInteger nCheckinIndex = nDiffMinutes / nTimeInterval;
            
//            if (nDiffMinutes % 15 > 0) {
//                nCheckinIndex++;
//            }
            
            NSNumber *numberCheckin = [arrayCheckins objectAtIndex: nCheckinIndex];
            
            if (numberCheckin == nil) {
                numberCheckin = [NSNumber numberWithInteger: 0];
            }
            
            NSInteger nVal = [numberCheckin integerValue];
            
            numberCheckin = [NSNumber numberWithInteger: nVal + 1];
            
            if (nVal + 1 > nMaxVal) {
                nMaxVal = nVal + 1;
            }
            
            [arrayCheckins replaceObjectAtIndex:nCheckinIndex withObject:numberCheckin];
        }
        
        [df release];
        
        if (nMaxVal < 10) {
            nMaxVal = 10;
        }
        
		lineChartView.minValue = 0;
		lineChartView.maxValue = nMaxVal;
        lineChartView.interval = nMaxVal / 10;
        
		[self addSubview:lineChartView];
        
        NSMutableArray *components = [NSMutableArray array];
        
        PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
        [component setPoints: arrayCheckins];
        [component setShouldLabelValues:NO];
        [component setColour:PCColorRed];
        
        [components addObject:component];
		
		[lineChartView setComponents:components];
      //  [lineChartView setXLabelFont: [UIFont systemFontOfSize: 8.0]];
      //  [lineChartView setXLabelFont: [UIFont systemFontOfSize:8.0]];
		[lineChartView setXLabels: titles];
    } else if (nGraphType == 2) {
        NSDictionary *dict = [dataKeeper.m_arrayCheckins objectAtIndex: nIndex];
        NSString *strName = [dict objectForKey:@"fullname"];
        NSString *strDate = [dict objectForKey:@"date"];
        [self setM_strImgURL: [dict objectForKey:@"picture"]];
        
        NSDate *date = [df dateFromString: strDate];
        [df setDateFormat:@"HH:mm"];
        
        NSString *strTime = [df stringFromDate: date];
    
        [m_labelName setText: strName];
        [m_labelTime setText: strTime];
        
        [self refreshImage];
        
        [m_viewLatestCheckins setHidden: NO];
        
    } else {
        [m_viewClearAll setHidden: NO];
        if ([dataKeeper.m_arrayCheckins count] >= 10 && dataKeeper.m_bPossibleClear == NO) {
            [m_btnClearAll setEnabled: NO];
            [m_labelClearAll setText:@"Please synchronize the list to be able to delete all checkins."];
        } else {
            [m_btnClearAll setEnabled: YES];
            [m_labelClearAll setText:@"List synchronized, you can delete all checkins now."];
        }
    }
    
    if (lineChartView != nil) {
        [lineChartView release];
    }
}

#pragma mark - Set Image to cell

- (void) refreshImage {
    [NSThread detachNewThreadSelector:@selector(getImage) toTarget:self withObject:nil];
}

- (void) getImage {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: m_strImgURL];
    
    [m_imgPhoto setImage: image];
    
    [autoreleasePool release];
}

@end
