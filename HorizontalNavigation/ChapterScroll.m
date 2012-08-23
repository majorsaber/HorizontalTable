//
//  ChapterScroll.m
//
//  Created by Sunny Purewal on 12-08-21.
//  Copyright 2012 Sunny Purewal. All rights reserved.
//

// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without
// limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
// AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
// OR OTHER DEALINGS IN THE SOFTWARE.

#import "ChapterScroll.h"

@interface ChapterScroll ()

-(int)itemsBeforeSection:(int)section;
-(int)itemsInSection:(int)section;
-(CGFloat)contentWidthForSection:(int)section;
-(CGFloat)contentWidthBeforeSection:(int)section;

@end

@implementation ChapterScroll

@synthesize topView, mainScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        items = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 40; i++) {
            UIView *rect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCSitemWidth, kCSitemWidth)];
            [rect setBackgroundColor:[UIColor blackColor]];
            UIView *innerRect = [[UIView alloc] initWithFrame:CGRectMake(5, 5, kCSitemWidth - 10, kCSitemWidth - 10)];
            UIColor *color;
            if (i < 5) {
                color = [UIColor redColor];
            }
            else if (i < 12) {
                color = [UIColor orangeColor];
            }
            else if (i < 24) {
                color = [UIColor yellowColor];
            }
            else if (i < 30) {
                color = [UIColor greenColor];
            }
            else {
                color = [UIColor blueColor];
            }
            [innerRect setBackgroundColor:color];
            [rect addSubview:innerRect];
            [items addObject:rect];
        }
        
        sectionCounts = [[NSMutableDictionary alloc] init];
        [sectionCounts setObject:[NSNumber numberWithInt:5] forKey:[NSNumber numberWithInt:0]];
        [sectionCounts setObject:[NSNumber numberWithInt:7] forKey:[NSNumber numberWithInt:1]];
        [sectionCounts setObject:[NSNumber numberWithInt:12] forKey:[NSNumber numberWithInt:2]];
        [sectionCounts setObject:[NSNumber numberWithInt:6] forKey:[NSNumber numberWithInt:3]];
        [sectionCounts setObject:[NSNumber numberWithInt:10] forKey:[NSNumber numberWithInt:4]];
        
        minIndex = INT_MAX;
        maxIndex = INT_MIN;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGFloat xLoc = 0;
    int sections = [sectionCounts count];
    sectionHeaders = [[NSMutableArray alloc] initWithCapacity:sections];
    for (int i = 0; i < sections; i++) {
        UIColor *color;
        switch (i) {
            case 0:
                color = [UIColor redColor];
                break;
            case 1:
                color = [UIColor orangeColor];
                break;
            case 2:
                color = [UIColor yellowColor];
                break;
            case 3:
                color = [UIColor greenColor];
                break;
            case 4:
                color = [UIColor blueColor];
                break;
        }
        UIButton *rect = [[UIButton alloc] initWithFrame:CGRectMake(xLoc, 0, 784, 44)];
        [rect setBackgroundColor:color];
        [sectionHeaders addObject:rect];
        xLoc += 120;
    }
    
    [topView setItems:sectionHeaders];
    [topView selectChapter:0];
    [self.mainScrollView performSelector:@selector(refreshData) withObject:nil afterDelay:0.3f];
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

-(int)itemsBeforeSection:(int)section
{
    int count = 0;
    for (int i = 0; i < section; i++) {
        count += [self itemsInSection:i];
    }
    
    return count;
}

-(int)itemsInSection:(int)section
{
    return [[sectionCounts objectForKey:[NSNumber numberWithInt:section]] intValue];
}

-(CGFloat)contentWidthForSection:(int)section
{
    return [self itemsInSection:section] * kCSitemWidth;
}

-(CGFloat)contentWidthBeforeSection:(int)section
{
    return [self itemsBeforeSection:section] * kCSitemWidth;
}

#pragma mark horizontal table view delegate
-(NSInteger)numberOfColumnsForTableView:(HorizontalTableView *)tableView
{
    return [items count];
}

-(CGFloat)columnWidthForTableView:(HorizontalTableView *)tableView
{
    return kCSitemWidth;
}

-(UIView *)tableView:(HorizontalTableView *)tableView viewForIndex:(NSInteger)index
{
    if (index < minIndex) {
        minIndex = index;
        maxIndex--;
    }
    else if (index > maxIndex) {
        maxIndex = index;
        minIndex++;
    }
    
    return [items objectAtIndex:index];
}

-(void)tableView:(HorizontalTableView *)tableView pageIndexDidChange:(NSInteger)index
{
    static int lastIndex = -1;
    int priorCount = 0;
    int i = 0;
    
    while (i < [sectionCounts count]) {
        if (lastIndex < index && index == priorCount) {
            [topView scrollToChapter:i];
            break;
        }
        else if (lastIndex > index && index == priorCount - 1) {
            [topView scrollToChapter:i];
            break;
        }
        
        priorCount += [self itemsInSection:i];
        i++;
    }
    
//    NSLog(@"%d,%d,%d",priorCount,i,index);
    
    lastIndex = index;
}

-(void)tableView:(HorizontalTableView *)tableView didScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    int i = 0;
    
    while ([self contentWidthBeforeSection:i] < offset) {
        i++;
    }
    
    if (i > 0) {
        i--;
    }
    
    CGFloat width = [self contentWidthForSection:i];
    offset = offset - [self contentWidthBeforeSection:i];
    CGFloat fraction = 1.0 - (offset/width);
    [topView revealSection:i byAmount:fraction];
}

#pragma mark scroll header delegate
-(void)scrollHeader:(ChapterTopScroll *)scrollHeader didSelectChapter:(int)index
{
    int chapterStart = 0;
    
    for (int i = 0; i < index; i++) {
        chapterStart += [[sectionCounts objectForKey:[NSNumber numberWithInt:i]] intValue];
    }
    
    [mainScrollView scrollToPage:chapterStart];
}
@end
