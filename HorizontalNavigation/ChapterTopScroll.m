//
//  ChapterTopScroll.m
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

#import "ChapterTopScroll.h"

@interface ChapterTopScroll()

@end

@implementation ChapterTopScroll

@synthesize items, delegate;

-(void)setItems:(NSMutableArray *)newItems
{
    items = newItems;
    int count = [items count];
    CGFloat itemWidth = 1024.0 - (peekWidth * (count-1));
    xTransform = 1024 - (120 * count+1);
    
    UIButton *item;
    CGFloat xLoc = 0;
    for (int i = 0; i < count; i++) {
        item = (UIButton*)[items objectAtIndex:i];
        [item setFrame:CGRectMake(xLoc, 0, itemWidth, 44)];
        [item setTag:i];
        [item addTarget:self action:@selector(didSelectChapter:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        
        xLoc += peekWidth;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        peekWidth = 120.0;
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        peekWidth = 120.0;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        peekWidth = 120.0;
    }
    return self;
}

-(void)selectChapter:(int)index
{
    [self scrollToChapter:index];
    
    [delegate scrollHeader:self didSelectChapter:index];
}

-(void)scrollToChapter:(int)index
{
    int count = [items count];
    
    for (int i = 0; i <= index; i++) {
        UIView *view = [items objectAtIndex:i];
        
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [view setTransform:CGAffineTransformMakeTranslation(0, 0)];
        }];
    }
    
    for (int i = count - 1; i > index; i--) {
        UIView *view = [items objectAtIndex:i];
        
        [UIView animateWithDuration:0.25 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [view setTransform:CGAffineTransformMakeTranslation(xTransform, 0)];
        }];
    }
}

-(void)revealSection:(int)section byAmount:(CGFloat)fraction
{
    CGFloat adjustedTransform = MAX(0,MIN(xTransform, fraction * xTransform));
    if (adjustedTransform < 0 || adjustedTransform > xTransform) {
        NSLog(@"%f",adjustedTransform);
    }
    int count = [items count];
    
    if (section < count - 1) {
        UIView *view = [items objectAtIndex:section+1];
        
        [UIView animateWithDuration:0.1 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [view setTransform:CGAffineTransformMakeTranslation(adjustedTransform, 0)];
        }];
    }
}

-(void)didSelectChapter:(id)sender
{
    UIButton *button = (UIButton*)sender;
    [self selectChapter:button.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
