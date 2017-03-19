//
//  MSQuadrantTile.h
//  MattSchrage
//
//  Created by Matt Schrage on 4/12/14.
//  Copyright (c) 2014 Matt Schrage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MSQuadrant) {
    MSQuadrantTopLeft,
    MSQuadrantTopRight,
    MSQuadrantBottomLeft,
    MSQuadrantBottomRight,
    MSQuadrantNone,
    
};

@class MSQuadrantTile;
@protocol MSQuadrantTileDelegate <NSObject>
- (void)quadrantTileWasTapped:(MSQuadrantTile *)tile;
@end

@interface MSQuadrantTile : UIView
@property (nonatomic, weak)id<MSQuadrantTileDelegate> delgate;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)UILabel *titleLabel;

- (void)setImage:(UIImage *)image;
- (void)setTitle:(NSString *)title;


@end
