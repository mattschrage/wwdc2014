//
//  MSQuadrantTile.m
//  MattSchrage
//
//  Created by Matt Schrage on 4/12/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import "MSQuadrantTile.h"

@implementation MSQuadrantTile

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];

        self.imageView = [[UIImageView alloc] init];
        self.imageView.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:self.imageView];
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,140, 50)];
        //[self.titleLabel setText: self.title];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:24]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}


- (void)setImage:(UIImage *)image{
    [self.imageView setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    self.imageView.tintColor = [UIColor accentedColorFromColor:self.backgroundColor];
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.imageView.center = CGPointMake(320/4,512/4 - 30);

  
}

- (void)setTitle:(NSString *)title{
    [self.titleLabel setText:title];
    self.titleLabel.center = CGPointMake(320/4,512/4+20);


}

- (void)tap:(UITapGestureRecognizer *)recognizer{

    [self.delgate quadrantTileWasTapped:self];
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
