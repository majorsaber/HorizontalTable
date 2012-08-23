//
//  ChapterNavigationViewController.m
//  ngc
//
//  Created by Sunny Purewal on 12-08-20.
//  Copyright (c) 2012 Bio-Rad. All rights reserved.
//

#import "ChapterNavigationViewController.h"

@interface ChapterNavigationViewController ()

@end

@implementation ChapterNavigationViewController

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
    
    ChapterScroll *chapterView = [[ChapterScroll alloc] initWithNibName:@"ChapterScroll" bundle:[NSBundle mainBundle]];
    [self addChildViewController:chapterView];
    [self.view addSubview:chapterView.view];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
