//
//  MSInterestSelectorViewController.m
//  MattSchrage
//
//  Created by Matt Schrage on 4/11/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import "MSQuadrantSelectorViewController.h"
#import "MSTutorialView.h"
@interface MSQuadrantSelectorViewController (){
    MSQuadrantTile *topLeft;
    MSQuadrantTile *topRight;
    MSQuadrantTile *bottomLeft;
    MSQuadrantTile *bottomRight;
    
    UIToolbar *statusBarView;
}

@end

@implementation MSQuadrantSelectorViewController

#pragma mark - ViewController -

- (void)viewDidLoad{
    
    [self setNeedsStatusBarAppearanceUpdate];
  
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.view.bounds];
    [toolbar setBarStyle:UIBarStyleBlack];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:toolbar];

    self.selectedQuadrant = MSQuadrantNone;
    
    topLeft = [[MSQuadrantTile alloc] initWithFrame:[self tileFrameForQuadrant:MSQuadrantTopLeft]];
    topLeft.delgate = self;
    topLeft.backgroundColor = [UIColor topLeftColor];
    [topLeft setImage:[UIImage imageNamed:@"iphone.png"]];
    [topLeft setTitle:@"Apps"];
    [self.view addSubview:topLeft];

    
    topRight = [[MSQuadrantTile alloc] initWithFrame:[self tileFrameForQuadrant:MSQuadrantTopRight]];
    topRight.delgate = self;
    topRight.backgroundColor = [UIColor topRightColor];
    [topRight setImage:[UIImage imageNamed:@"book.png"]];
    [topRight setTitle:@"Education"];

    [self.view addSubview:topRight];

    bottomLeft = [[MSQuadrantTile alloc] initWithFrame:[self tileFrameForQuadrant:MSQuadrantBottomLeft]];
    bottomLeft.delgate = self;
    bottomLeft.backgroundColor = [UIColor bottomLeftColor];
    [bottomLeft setImage:[UIImage imageNamed:@"chart.png"]];
    [bottomLeft setTitle:@"Work"];

    [self.view addSubview:bottomLeft];

    
    bottomRight = [[MSQuadrantTile alloc] initWithFrame:[self tileFrameForQuadrant:MSQuadrantBottomRight]];
    bottomRight.delgate = self;
    bottomRight.backgroundColor = [UIColor bottomRightColor];
    [bottomRight setImage:[UIImage imageNamed:@"share.png"]];
    [bottomRight setTitle:@"About Me"];
    [self.view addSubview:bottomRight];

    
    self.picker = [[MSCircularSelector alloc] initWithRadius:35.0f andCenter:self.view.center andImage:[UIImage imageNamed:@"matt.png"]];
    self.picker.delegate = self;
    [self.view addSubview:self.picker];
        
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-15);
    verticalMotionEffect.maximumRelativeValue = @(15);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-15);
    horizontalMotionEffect.maximumRelativeValue = @(15);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self.picker addMotionEffect:group];
    
    MSTutorialView *tutorial = [[MSTutorialView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tutorial];
    
    statusBarView = [[UIToolbar alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    [statusBarView setBarStyle:UIBarStyleBlack];
    statusBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:statusBarView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Picker, Tile & ViewController Delegates -

- (void)selectionDidBegin:(MSCircularSelector *)picker{

    int delta = 13;
    topLeft.layer.shadowOpacity = 0.25;
    topRight.layer.shadowOpacity = 0.25;
    bottomLeft.layer.shadowOpacity = 0.25;
    bottomRight.layer.shadowOpacity = 0.25;
    
    
    topLeft.layer.shadowOffset = CGSizeMake(delta/2, delta/2);
    topRight.layer.shadowOffset  = CGSizeMake(- delta/2, delta/2);
    bottomLeft.layer.shadowOffset  = CGSizeMake(delta/2, - delta/2);
    bottomRight.layer.shadowOffset  = CGSizeMake(- delta/2,  - delta/2);

    [UIView animateWithDuration:0.25 animations:^{
        topLeft.center = CGPointMake(topLeft.center.x - delta, topLeft.center.y - delta);
        topRight.center = CGPointMake(topRight.center.x + delta, topRight.center.y - delta);
        bottomLeft.center = CGPointMake(bottomLeft.center.x - delta, bottomLeft.center.y + delta);
        bottomRight.center = CGPointMake(bottomRight.center.x + delta, bottomRight.center.y + delta);

    }];
    
}

- (void)selectionDidEnd:(MSCircularSelector *)picker{
    self.selectedQuadrant = [self selectedQuadrantForPicker:picker];
    
    switch (self.selectedQuadrant){
            
        case MSQuadrantTopLeft:{
            [UIView animateWithDuration:0.5 animations:^{
                topLeft.frame = self.view.frame;
                topLeft.titleLabel.alpha = 0;
                topLeft.imageView.alpha = 0;
                
                statusBarView.alpha = 0;
                
                picker.alpha = 0;
                picker.shouldResize = NO;
                [picker setTransform:CGAffineTransformMakeScale (0, 0)];
            }completion:^(BOOL finished) {
                /// Transition to next view controller
                MSInformationViewController *v = [[MSInformationViewController alloc] init];
                v.delegate = self;
                v.color = [UIColor topLeftColor];
                v.identifier = @"apps";
                //v.view.tintColor = v.color;
                
                
                NSString *fileName = [NSString stringWithFormat:@"%@/%@.txt",
                                      [[NSBundle mainBundle] bundlePath],v.identifier];
                NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                                usedEncoding:nil
                                                                       error:nil];
                
                v.text = content;

                v.title = topLeft.titleLabel.text;
                v.numberOfPictures = 8;
                [self presentViewController:v animated:NO completion:nil];
            }];
            break;
        }
        case MSQuadrantTopRight:{
            [UIView animateWithDuration:0.5 animations:^{
                topRight.frame = self.view.frame;
                topRight.titleLabel.alpha = 0;
                topRight.imageView.alpha = 0;
                
                statusBarView.alpha = 0;
                
                picker.alpha = 0;
                picker.shouldResize = NO;
                [picker setTransform:CGAffineTransformMakeScale (0, 0)];
            }completion:^(BOOL finished) {
                /// Transition to next view controller
                MSInformationViewController *v = [[MSInformationViewController alloc] init];
                v.delegate = self;
                v.color = [UIColor topRightColor];
                v.identifier = @"education";

                NSString *fileName = [NSString stringWithFormat:@"%@/%@.txt",
                                      [[NSBundle mainBundle] bundlePath],v.identifier];
                NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                                usedEncoding:nil
                                                                       error:nil];
                
                v.text = content;

                v.title = topRight.titleLabel.text;
                [v setNumberOfPictures:1];
                [self presentViewController:v animated:NO completion:nil];
            }];
            break;
        }
        case MSQuadrantBottomLeft:{
            [UIView animateWithDuration:0.5 animations:^{
                bottomLeft.frame = self.view.frame;
                bottomLeft.titleLabel.alpha = 0;
                bottomLeft.imageView.alpha = 0;
                
                statusBarView.alpha = 0;
                
                picker.alpha = 0;
                picker.shouldResize = NO;
                [picker setTransform:CGAffineTransformMakeScale (0, 0)];
            }completion:^(BOOL finished) {
                /// Transition to next view controller
                /// Transition to next view controller
                MSInformationViewController *v = [[MSInformationViewController alloc] init];
                v.delegate = self;
                v.color = [UIColor bottomLeftColor];
                v.identifier = @"work";

                NSString *fileName = [NSString stringWithFormat:@"%@/%@.txt",
                                      [[NSBundle mainBundle] bundlePath],v.identifier];
                NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                                usedEncoding:nil
                                                                       error:nil];
                
                v.text = content;
                //v.view.tintColor = v.color;
                v.title = bottomLeft.titleLabel.text;
                [v setNumberOfPictures:3];
                [self presentViewController:v animated:NO completion:nil];

            }];
            break;
        }
        case MSQuadrantBottomRight:{
            [UIView animateWithDuration:0.5 animations:^{
                bottomRight.frame = self.view.frame;
                bottomRight.titleLabel.alpha = 0;
                bottomRight.imageView.alpha = 0;
                
                statusBarView.alpha = 0;
                
                picker.alpha = 0;
                picker.shouldResize = NO;
                [picker setTransform:CGAffineTransformMakeScale (0, 0)];
            }completion:^(BOOL finished) {
                /// Transition to next view controller
                /// Transition to next view controller
                MSInformationViewController *v = [[MSInformationViewController alloc] init];
                v.delegate = self;
                v.color = [UIColor bottomRightColor];
                //v.view.tintColor = v.color;
                v.identifier = @"other";
                
                NSString *fileName = [NSString stringWithFormat:@"%@/%@.txt",
                                      [[NSBundle mainBundle] bundlePath],v.identifier];
                NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                                usedEncoding:nil
                                                                       error:nil];
                
                v.text = content;
                
                v.title = bottomRight.titleLabel.text;
                v.numberOfPictures = 4;
                [v setNumberOfPictures:3];
                [self presentViewController:v animated:NO completion:nil];

            }];
            break;
        }
        case MSQuadrantNone:{
            int delta = 13;
        
            [UIView animateWithDuration:0.25 animations:^{
                [topLeft setTransform:CGAffineTransformMakeScale (1, 1)];
                [topRight setTransform:CGAffineTransformMakeScale (1, 1)];
                [bottomLeft setTransform:CGAffineTransformMakeScale (1, 1)];
                [bottomRight setTransform:CGAffineTransformMakeScale (1, 1)];
                
                topLeft.alpha = 1;
                topRight.alpha = 1;
                bottomLeft.alpha = 1;
                bottomRight.alpha = 1;
                
                topLeft.center = CGPointMake(topLeft.center.x + delta, topLeft.center.y + delta);
                topRight.center = CGPointMake(topRight.center.x - delta, topRight.center.y + delta);
                bottomLeft.center = CGPointMake(bottomLeft.center.x + delta, bottomLeft.center.y - delta);
                bottomRight.center = CGPointMake(bottomRight.center.x - delta, bottomRight.center.y - delta);
                
                picker.center = picker.initialCenter;
                
            } completion:^(BOOL finished) {
                topLeft.layer.shadowOpacity = 0;
                topRight.layer.shadowOpacity = 0;
                bottomLeft.layer.shadowOpacity = 0;
                bottomRight.layer.shadowOpacity = 0;
            }];

            break;
        }
            
        default:
            break;
    }
}

- (void)positionDidChange:(MSCircularSelector *)picker{
    switch ([self selectedQuadrantForPicker:picker]) {
        case MSQuadrantTopLeft:{
            [self.view bringSubviewToFront:topLeft];
            [self.view bringSubviewToFront:picker];
            [self.view bringSubviewToFront:statusBarView];
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [topLeft setTransform:CGAffineTransformMakeScale (1.35, 1.25)];

            } completion:nil];
            
            [UIView animateWithDuration:0.15 animations:^{
                [topRight setTransform:CGAffineTransformMakeScale (1, 1)];
                [bottomLeft setTransform:CGAffineTransformMakeScale (1, 1)];
                [bottomRight setTransform:CGAffineTransformMakeScale (1, 1)];
                
                topLeft.alpha = 1;
                topRight.alpha = 0.5;
                bottomLeft.alpha = 0.5;
                bottomRight.alpha = 0.5;
                
            }];

            break;
        }
        case MSQuadrantTopRight:{
            [self.view bringSubviewToFront:topRight];
            [self.view bringSubviewToFront:picker];
            [self.view bringSubviewToFront:statusBarView];
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [topRight setTransform:CGAffineTransformMakeScale (1.35, 1.25)];

            } completion:nil];
            
            [UIView animateWithDuration:0.15 animations:^{
                [topLeft setTransform:CGAffineTransformMakeScale (1, 1)];
                [bottomLeft setTransform:CGAffineTransformMakeScale (1, 1)];
                [bottomRight setTransform:CGAffineTransformMakeScale (1, 1)];
                
                topLeft.alpha = 0.5;
                topRight.alpha = 1;
                bottomLeft.alpha = 0.5;
                bottomRight.alpha = 0.5;
            }];

            break;
        }
        case MSQuadrantBottomLeft:{
            [self.view bringSubviewToFront:bottomLeft];
            [self.view bringSubviewToFront:picker];
            [self.view bringSubviewToFront:statusBarView];

            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [bottomLeft setTransform:CGAffineTransformMakeScale (1.35, 1.25)];
                
            } completion:nil];
            
            [UIView animateWithDuration:0.15 animations:^{
                [topLeft setTransform:CGAffineTransformMakeScale (1, 1)];
                [topRight setTransform:CGAffineTransformMakeScale (1, 1)];
                [bottomRight setTransform:CGAffineTransformMakeScale (1, 1)];
                
                topLeft.alpha = 0.5;
                topRight.alpha = 0.5;
                bottomLeft.alpha = 1;
                bottomRight.alpha = 0.5;
            }];

            break;
        }
        case MSQuadrantBottomRight:{
            [self.view bringSubviewToFront:bottomRight];
            [self.view bringSubviewToFront:picker];
            [self.view bringSubviewToFront:statusBarView];

            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                [bottomRight setTransform:CGAffineTransformMakeScale (1.35, 1.25)];
                

                
            } completion:nil];
            
            [UIView animateWithDuration:0.15 animations:^{
                [topLeft setTransform:CGAffineTransformMakeScale (1, 1)];
                [topRight setTransform:CGAffineTransformMakeScale (1, 1)];
                [bottomLeft setTransform:CGAffineTransformMakeScale (1, 1)];
                
                topLeft.alpha = 0.5;
                topRight.alpha = 0.5;
                bottomLeft.alpha = 0.5;
                bottomRight.alpha = 1;
            }];

            break;
        }
        case MSQuadrantNone:{
            
            [UIView animateWithDuration:0.15 animations:^{
                [topLeft setTransform:CGAffineTransformMakeScale (1, 1)];
                [topRight setTransform:CGAffineTransformMakeScale (1, 1)];
                [bottomLeft setTransform:CGAffineTransformMakeScale (1, 1)];
                [bottomRight setTransform:CGAffineTransformMakeScale (1, 1)];
                
                topLeft.alpha = 1;
                topRight.alpha = 1;
                bottomLeft.alpha = 1;
                bottomRight.alpha = 1;
            }];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)quadrantTileWasTapped:(MSQuadrantTile *)tile{
    
    int delta = 13;
    topLeft.layer.shadowOpacity = 0.25;
    topRight.layer.shadowOpacity = 0.25;
    bottomLeft.layer.shadowOpacity = 0.25;
    bottomRight.layer.shadowOpacity = 0.25;
    
    
    topLeft.layer.shadowOffset = CGSizeMake(delta/2, delta/2);
    topRight.layer.shadowOffset  = CGSizeMake(- delta/2, delta/2);
    bottomLeft.layer.shadowOffset  = CGSizeMake(delta/2, - delta/2);
    bottomRight.layer.shadowOffset  = CGSizeMake(- delta/2,  - delta/2);
    
    [UIView animateWithDuration:0.25 animations:^{
        topLeft.center = CGPointMake(topLeft.center.x - delta, topLeft.center.y - delta);
        topRight.center = CGPointMake(topRight.center.x + delta, topRight.center.y - delta);
        bottomLeft.center = CGPointMake(bottomLeft.center.x - delta, bottomLeft.center.y + delta);
        bottomRight.center = CGPointMake(bottomRight.center.x + delta, bottomRight.center.y + delta);
        
    }completion:^(BOOL finished) {
        int delta = 13;
        
        [UIView animateWithDuration:0.25 animations:^{
            [topLeft setTransform:CGAffineTransformMakeScale (1, 1)];
            [topRight setTransform:CGAffineTransformMakeScale (1, 1)];
            [bottomLeft setTransform:CGAffineTransformMakeScale (1, 1)];
            [bottomRight setTransform:CGAffineTransformMakeScale (1, 1)];
            
            topLeft.alpha = 1;
            topRight.alpha = 1;
            bottomLeft.alpha = 1;
            bottomRight.alpha = 1;
            
            topLeft.center = CGPointMake(topLeft.center.x + delta, topLeft.center.y + delta);
            topRight.center = CGPointMake(topRight.center.x - delta, topRight.center.y + delta);
            bottomLeft.center = CGPointMake(bottomLeft.center.x + delta, bottomLeft.center.y - delta);
            bottomRight.center = CGPointMake(bottomRight.center.x - delta, bottomRight.center.y - delta);
            
            
        } completion:^(BOOL finished) {
            topLeft.layer.shadowOpacity = 0;
            topRight.layer.shadowOpacity = 0;
            bottomLeft.layer.shadowOpacity = 0;
            bottomRight.layer.shadowOpacity = 0;
        }];
        
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.picker.center = CGPointMake(self.picker.center.x + (tile.center.x - self.view.center.x)/4, self.picker.center.y + (tile.center.y - self.view.center.y)/4);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.picker.center = self.picker.initialCenter;
        }];
    }];
    
    
}

- (void)informationViewControllerWasDismissed:(MSInformationViewController *)viewController{
    
    switch (self.selectedQuadrant) {
        case MSQuadrantTopLeft:{
            [UIView animateWithDuration:0.5 animations:^{
                topLeft.transform = CGAffineTransformMakeScale(1, 1);
            }];
            break;
        }
            
        case MSQuadrantTopRight:{
            [UIView animateWithDuration:0.5 animations:^{
                topRight.transform = CGAffineTransformMakeScale(1, 1);
            }];
            break;
        }
            
        case MSQuadrantBottomLeft:{
            [UIView animateWithDuration:0.5 animations:^{
                bottomLeft.transform = CGAffineTransformMakeScale(1, 1);
            }];
            break;
        }
            
        case MSQuadrantBottomRight:{
            [UIView animateWithDuration:0.5 animations:^{
                bottomRight.transform = CGAffineTransformMakeScale(1, 1);
            }];
            break;
        }
            
        default:
            break;
    }
    self.picker.center = self.picker.initialCenter;
    self.picker.shouldResize = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        statusBarView.alpha = 1;
        
        topLeft.frame = [self tileFrameForQuadrant:MSQuadrantTopLeft];
        topLeft.alpha = 1;
        topLeft.titleLabel.alpha = 1;
        topLeft.imageView.alpha = 1;
        
        topRight.frame = [self tileFrameForQuadrant:MSQuadrantTopRight];
        topRight.alpha = 1;
        topRight.titleLabel.alpha = 1;
        topRight.imageView.alpha = 1;
        
        bottomLeft.frame = [self tileFrameForQuadrant:MSQuadrantBottomLeft];
        bottomLeft.alpha = 1;
        bottomLeft.titleLabel.alpha = 1;
        bottomLeft.imageView.alpha = 1;
        
        bottomRight.frame = [self tileFrameForQuadrant:MSQuadrantBottomRight];
        bottomRight.alpha = 1;
        bottomRight.titleLabel.alpha = 1;
        bottomRight.imageView.alpha = 1;
        
        
        
    }completion:^(BOOL finished) {
        topLeft.layer.shadowOpacity = 0;
        topRight.layer.shadowOpacity = 0;
        bottomLeft.layer.shadowOpacity = 0;
        bottomRight.layer.shadowOpacity = 0;
        
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.picker.transform = CGAffineTransformIdentity;
            self.picker.alpha = 1;
        }completion:nil];
    }];
    
    self.selectedQuadrant = MSQuadrantNone;
}

#pragma mark - Quadrant Helper Methods -

- (CGRect)tileFrameForQuadrant:(MSQuadrant)quadrant{
    
    switch (quadrant) {
        case MSQuadrantTopLeft:{
            return CGRectMake(0, 0, CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
            break;
        }
        case MSQuadrantTopRight:{
            return CGRectMake(CGRectGetWidth(self.view.frame)/2, 0, CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
            break;
        }
        case MSQuadrantBottomLeft:{
            return CGRectMake(0,  CGRectGetHeight(self.view.frame)/2, CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
            break;
        }
        case MSQuadrantBottomRight:{
            return CGRectMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2, CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
            break;
        }
            
        default:{
            return CGRectNull;
            break;
        }
    }
}

- (MSQuadrant)selectedQuadrantForPicker:(MSCircularSelector *)picker{
    if(CGRectContainsPoint(topLeft.frame, picker.center))return MSQuadrantTopLeft;
    else if(CGRectContainsPoint(topRight.frame, picker.center))return MSQuadrantTopRight;
    else if(CGRectContainsPoint(bottomLeft.frame, picker.center))return MSQuadrantBottomLeft;
    else if(CGRectContainsPoint(bottomRight.frame, picker.center))return MSQuadrantBottomRight;
    else return MSQuadrantNone;
}




@end
