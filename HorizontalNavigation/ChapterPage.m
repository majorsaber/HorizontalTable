//
//  ChapterPage.m
//
//  Created by Sunny Purewal on 12-08-27.
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

#import "ChapterPage.h"

@implementation ChapterPage

@synthesize isActive, page, overlay, titleLabel, image;

-(void)setIsActive:(BOOL)active
{
    isActive = active;
    
    if (active) {
        [UIView animateWithDuration:0.25 animations:^{
            [overlay setAlpha:0];
            [titleLabel setAlpha:0];
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            [overlay setAlpha:0.25];
            [titleLabel setAlpha:1];
        }];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        page = [[UIView alloc] initWithFrame:CGRectMake(5, 4, 190, 142)];
        [self addSubview:page];
        
        overlay = [[UIView alloc] initWithFrame:CGRectMake(5, 4, 190, 142)];
        [overlay setBackgroundColor:[UIColor blackColor]];
        [overlay setAlpha:0.3];
        [self addSubview:overlay];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 66, 160, 21)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor lightTextColor]];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
        [self addSubview:titleLabel];
        
        image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 190, 142)];
        //[imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"config1-nav.jpg"]]];
        
        [page addSubview:image];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setImageView:(NSString *)imageName{
    [image setImage:[UIImage imageNamed:imageName]];
    
}

@end
