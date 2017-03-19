//
//  MSTutorialView.m
//  MattSchrage
//
//  Created by Matt Schrage on 4/13/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import "MSTutorialView.h"

@implementation MSTutorialView{


}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSLog(@"self.superview.bounds");
        
        self.frame = frame;
        
        UIView *backdrop = [[UIView alloc] initWithFrame:frame];
        backdrop.backgroundColor = [UIColor blackColor];
        backdrop.alpha = 0.85;
        [self addSubview:backdrop];
        
        
         UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tutorial.png"]];
         imageView.frame = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
         imageView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2 - 100);
        
        [self addSubview:imageView];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 50)];
         l.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame) - 35);
         [l setTextAlignment:NSTextAlignmentCenter];
         [l setText:@"Tap anywhere to continue..."];
         [l setTextColor:[UIColor whiteColor]];
         [l setFont:[UIFont fontWithName:@"Chalkduster" size:20]];
         [self addSubview:l];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}


- (void)tap{

    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
