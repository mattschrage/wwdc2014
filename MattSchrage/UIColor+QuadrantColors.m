//
//  UIColor+QuadrantColors.m
//  MattSchrage
//
//  Created by Matt Schrage on 4/12/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import "UIColor+QuadrantColors.h"

@implementation UIColor (QuadrantColors)
///Color Scheme from http://flatuicolors.com/

///rgb(22, 160, 133)
+ (UIColor *)topLeftColor{return [UIColor colorWithRed:22/255.0f green:160/255.0f blue:133/255.0f alpha:1];}
///rgb(39, 174, 96)
+ (UIColor *)topRightColor{return [UIColor colorWithRed:39/255.0f green:174/255.0f blue:96/255.0f alpha:1];}
///rgb(241, 196, 15)
+ (UIColor *)bottomLeftColor{return [UIColor colorWithRed:241/255.0f green:196/255.0f blue:15/255.0f alpha:1];}
///rgb(230, 126, 34)
+ (UIColor *)bottomRightColor{return [UIColor colorWithRed:230/255.0f green:126/255.0f blue:34/255.0f alpha:1];}


+ (UIColor *)accentedColorFromColor:(UIColor *)color{
    const CGFloat* components = CGColorGetComponents(color.CGColor);

    return [UIColor colorWithRed:components[0]+0.2 green:components[1]+0.2 blue:components[2]+0.2 alpha:1];
}

@end
