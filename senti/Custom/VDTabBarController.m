//
// Copyright 2010-2011 Vincent Demay
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


#import "VDTabBarController.h"
#import "VDButton.h"

@interface VDTabBarController (Private) 
-(void) computePosition;
-(void) selectTab:(int)tabID;
@end

//////////////////////////////////////////////////////////////////////////////////////////////

@implementation VDTabBarController

- (void)viewDidLoad {
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabback.png"]];
    
    backView.frame = self.tabBar.frame;
    
   // [self.view addSubview:backView];
    
    [backView release];

    [super viewDidLoad];
}

- (void)loadView {
    [super loadView];
    
	_overbuttons = [[NSMutableArray alloc] initWithCapacity:self.tabBar.items.count];
	tabImages = [[NSMutableArray alloc] initWithCapacity:self.tabBar.items.count];
    tabselImages = [[NSMutableArray alloc] initWithCapacity:self.tabBar.items.count];
	
    [tabImages addObject:@"tab-q-inactive.png"];
	[tabImages addObject:@"tab-feed-inactive.png"];
	[tabImages addObject:@"tab-friends-inactive.png"];
	[tabImages addObject:@"tab-profile-inactive.png"];
    [tabImages addObject:@"tab-settings-inactive.png"];
    
    [tabselImages addObject:@"tab-q-active.png"];
    [tabselImages addObject:@"tab-feed-active.png"];
	[tabselImages addObject:@"tab-friends-active.png"];
	[tabselImages addObject:@"tab-profile-active.png"];
    [tabselImages addObject:@"tab-settings-active.png"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addCustomElements];
    
    //[self.tabBar setFrame: CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, 44)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation == UIInterfaceOrientationPortrait)
		return YES;
	else
		return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self computePosition];
}


- (void)dealloc {
	[_overbuttons release];
	[tabImages release];
    [tabselImages release];
	_overbuttons = nil;
	[_from release];
	_from = nil;
	[_to release];
	_to = nil;
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark configuration
- (void) reflexiveColor:(UIColor*) color {
    _from = [color retain];
    _style = VDTabBarReflexiveStyle;

    [self addCustomElements];
}

- (void) gradientColorFrom:(UIColor*)from to:(UIColor*) to {
    _from = [from retain];
    _to = [to retain];
    _style = VDTabBarGradientStyle;

    [self addCustomElements];
}

////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark private

-(void) computePosition {
	CGFloat topOfTabBar = self.tabBar.frame.origin.y;
	
	CGFloat itemSize = 60;
	
	for (int i=0; i<_overbuttons.count; i++) {
		VDButton *current = (VDButton*)[_overbuttons objectAtIndex:i];
		//current.hidden = NO;
        if (i == 0) {
            current.frame = CGRectMake(0, topOfTabBar, 80, 49);
        } else {
            current.frame = CGRectMake(itemSize * i + 20, topOfTabBar, 60, 49);
        }

	}
}


-(void)addCustomElements
{
    CGFloat topOfTabBar = self.tabBar.frame.origin.y;

    CGFloat itemSize = 60;

    for (UIView* button in _overbuttons)
        [button removeFromSuperview];
    [_overbuttons removeAllObjects];
    
   
    for (int i = 0; i < self.tabBar.items.count; i++) {
        // Initialise our two images
        UIImage *btnImage = [UIImage imageNamed:[tabImages objectAtIndex:i]];//((UITabBarItem*)[self.tabBar.items objectAtIndex:i]).image;
        
         UIImage *btnImage_sel = [UIImage imageNamed:[tabselImages objectAtIndex:i]];//((UITabBarItem*)[self.tabBar.items objectAtIndex:i]).image;
        ((UITabBarItem*)[self.tabBar.items objectAtIndex:i]).image = nil;

        VDButton* current = [VDButton buttonWithType:UIButtonTypeCustom]; //Setup the button
        
        [current setBackgroundImage:btnImage forState:UIControlStateNormal];
        [current setBackgroundImage:btnImage_sel forState:UIControlStateSelected];
            
        if (i == 0) {
            current.frame = CGRectMake(0, topOfTabBar, 80, 49);
        } else {
            current.frame = CGRectMake(itemSize * i + 20, topOfTabBar, 60, 49);
        }
        
        [current setTag:i];
        if ((self.tabBar.selectedItem == nil && i==0) || [self.tabBar.items objectAtIndex:i] == self.tabBar.selectedItem) {
            [current setSelected:YES];
        }

        [self.view addSubview:current];
        [current addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_overbuttons addObject:current];
    }
}

- (void)buttonClicked:(id)sender
{
	int tagNum = [sender tag];
	[self selectTab:tagNum];
}


- (void)selectTab:(int)tabID
{
	for (int i = 0; i < self.tabBar.items.count; i++) {
		UIButton* current = (UIButton*)[_overbuttons objectAtIndex:i];
		if (i == tabID) {
			[current setSelected:YES];
		} else {
			[current setSelected:NO];
		}
	}
	self.selectedIndex = tabID;
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	for (int i = 0; i < self.tabBar.items.count; i++) {
		UIButton* current = (UIButton*)[_overbuttons objectAtIndex:i];
		if ([self.tabBar.items objectAtIndex:i] == item) {
			[current setSelected:YES];
		} else {
			[current setSelected:NO];
		}
	}
}

- (void)setViewControllers:(NSArray*)vcs
{
    [super setViewControllers:vcs];
    [self addCustomElements];
}

- (void)setSelectedIndex:(NSUInteger)idx
{
    [super setSelectedIndex:idx];
/*
    for (int i=0; i<self.tabBar.items.count; i++) {
        UIButton* current = (UIButton*)[_overbuttons objectAtIndex:i];
        [current setSelected:(idx==i)];
    }
 */
}

@end
