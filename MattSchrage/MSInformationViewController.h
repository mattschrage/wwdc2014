//
//  MSInformationViewController.h
//  MattSchrage
//
//  Created by Matt Schrage on 4/12/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSInformationViewController;
@protocol MSInformationViewControllerDelegate <NSObject>
@optional
- (void)informationViewControllerWillBeDismissed:(MSInformationViewController *)viewController;
- (void)informationViewControllerWasDismissed:(MSInformationViewController *)viewController;


@end

@interface MSInformationViewController : UIViewController <UIScrollViewDelegate>{
    UITextView *viewer;

    UIScrollView *scrollview;
    int index;
}
@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, assign)NSUInteger numberOfPictures;
@property (nonatomic, assign)NSString *identifier;
@property (nonatomic, weak)id<MSInformationViewControllerDelegate> delegate;

- (id)initWithIdentifier:(NSString *)identifier andColor:(UIColor *)color;

@end
