//
//  UIColor+QuadrantColors.h
//  MattSchrage
//
//  Created by Matt Schrage on 4/12/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QuadrantColors)
+ (UIColor *)topLeftColor;
+ (UIColor *)topRightColor;
+ (UIColor *)bottomLeftColor;
+ (UIColor *)bottomRightColor;

+ (UIColor *)accentedColorFromColor:(UIColor *)color;

@end
