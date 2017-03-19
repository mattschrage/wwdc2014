//
//  MSInterestSelectorViewController.h
//  MattSchrage
//
//  Created by Matt Schrage on 4/11/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCircularSelector.h"
#import "MSQuadrantTile.h"
#import "MSInformationViewController.h"

@interface MSQuadrantSelectorViewController : UIViewController <MSCircularSelectorDelegate,MSQuadrantTileDelegate,MSInformationViewControllerDelegate>
@property (nonatomic, assign)MSQuadrant selectedQuadrant;
@property (nonatomic, strong)MSCircularSelector *picker;
@end
