//
//  MSInformationViewController.m
//  MattSchrage
//
//  Created by Matt Schrage on 4/12/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import "MSInformationViewController.h"
#import "MSTutorialView.h"

@interface MSInformationViewController (){
    UIPageControl *page;
    UILabel *titleLabel;
    UIButton *backButton;
}

@end

@implementation MSInformationViewController

- (id)initWithIdentifier:(NSString *)identifier andColor:(UIColor *)color{
    self = [super init];
    
    if(self){
        self.color = color;

        self.identifier = identifier;
        
    
    }
    
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    [self transitionAllViewsToOpacity:1.0 withDuration:0.5];
    
}

- (void)transitionAllViewsToOpacity:(CGFloat)opacity withDuration:(CGFloat)duration{
    [UIView animateWithDuration:duration animations:^{
        backButton.alpha = opacity;
        titleLabel.alpha = opacity;
        scrollview.alpha = opacity;
        viewer.alpha = opacity;
        page.alpha = opacity;
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addStatusBar];

    self.view.backgroundColor = self.color;

    
    scrollview =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)/3 - 20)];
    scrollview.delegate = self;
    scrollview.contentSize = CGSizeMake(self.numberOfPictures * CGRectGetWidth(scrollview.frame), 0);
    scrollview.pagingEnabled = YES;
    scrollview.backgroundColor = self.color;
    [scrollview setShowsHorizontalScrollIndicator:NO];

    for (int x = 1; x <= self.numberOfPictures; x++) {

        [scrollview addSubview:[self viewForIndex:x-1]];
    }
    
    [self.view addSubview:scrollview];
    
    viewer = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)/3 + 70, CGRectGetWidth(self.view.frame), 2*CGRectGetHeight(self.view.frame)/3 - 70)];
    viewer.tintColor = [UIColor accentedColorFromColor:self.view.backgroundColor];
    viewer.backgroundColor = self.color;
    viewer.dataDetectorTypes = UIDataDetectorTypeLink;
    viewer.text = self.text;
    viewer.textContainerInset = UIEdgeInsetsMake(5.0f, 10.0f, 0.0f, 10.0f);
    viewer.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor accentedColorFromColor:self.view.backgroundColor]};
    [viewer setTextColor:[UIColor whiteColor]];
    [viewer setFont:[UIFont fontWithName:@"Avenir-Book" size:24]];
    viewer.editable = NO;
    [self.view addSubview:viewer];
    
    CAGradientLayer *alphaGradientLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       nil];
    [alphaGradientLayer setColors:colors];
    
    // Start the gradient at the bottom and go almost half way up.
    [alphaGradientLayer setStartPoint:CGPointMake(0.0f, 1.0f)];
    [alphaGradientLayer setEndPoint:CGPointMake(0.0f, 0.6f)];
    
    // Create a image view for the topImage we created above and apply the mask
    UIView *gradient = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)/3 + 65, CGRectGetWidth(self.view.frame) , 20)];
    gradient.backgroundColor = self.color;
    [alphaGradientLayer setFrame:[gradient bounds]];
    [[gradient layer] setMask:alphaGradientLayer];
    
    [self.view addSubview:gradient];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20,CGRectGetWidth(self.view.frame), 50)];
    [titleLabel setText: self.title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:24]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 20, 50 , 50);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"←" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:35];
    backButton.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:backButton];
    
    page = [[UIPageControl alloc] init];
    [page setPageIndicatorTintColor:[UIColor accentedColorFromColor:self.view.backgroundColor]];
    [page setNumberOfPages:self.numberOfPictures];
    [page setCurrentPage:0];
    page.center = CGPointMake(self.view.center.x,scrollview.center.y + CGRectGetHeight(scrollview.frame)/2 + 10);
    [self.view addSubview:page];
    
    [self transitionAllViewsToOpacity:0 withDuration:0];
    
    [super viewDidLoad];

}

- (UIView *)viewForIndex:(NSUInteger)_index{
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(_index*CGRectGetWidth(scrollview.frame), 0, CGRectGetWidth(scrollview.frame), CGRectGetHeight(scrollview.frame))];
    
    v.userInteractionEnabled = YES;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%i.png",self.identifier,(int)_index]]];
    image.frame = CGRectMake(0, 0, CGRectGetWidth(v.frame), CGRectGetHeight(v.frame));
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.center = CGPointMake([v convertPoint:v.center fromView:self.view].x, [v convertPoint:v.center fromView:self.view].y);
    [v addSubview:image];
    
    return v;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    index = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [page setCurrentPage:index];
    
}


- (void)addStatusBar
{
    
    const CGFloat* components = CGColorGetComponents(self.color.CGColor);
    
    CGRect f = [[UIApplication sharedApplication] statusBarFrame];
    
    CAGradientLayer *statusBar = [CAGradientLayer layer];
    statusBar.frame = CGRectMake(0, 0, CGRectGetWidth(f), CGRectGetHeight(f)+10);
    statusBar.colors = [NSArray arrayWithObjects:
                        (id)[[UIColor colorWithRed:components[0]+0.1 green:components[1]+0.1 blue:components[2]+0.1 alpha:1] CGColor],
                        (id)[[UIColor colorWithRed:components[0]+0.1 green:components[1]+0.1 blue:components[2]+0.1 alpha:0.75] CGColor],
                        (id)[[UIColor colorWithRed:components[0]+0.1 green:components[1]+0.1 blue:components[2]+0.1 alpha:0] CGColor],nil];
    statusBar.locations = @[@0.0,@0.5,@1.0];
    [self.view.layer addSublayer:statusBar];
}

- (void)back{
    //[self.delegate informationViewControllerWillBeDismissed:self];
    [UIView animateWithDuration:0.5 animations:^{
        backButton.alpha = 0;
        titleLabel.alpha = 0;
        scrollview.alpha = 0;
        viewer.alpha = 0;
        page.alpha = 0;
    } completion:^(BOOL finished) {
       [self dismissViewControllerAnimated:NO completion:nil];
        [self.delegate informationViewControllerWasDismissed:self];

    }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
