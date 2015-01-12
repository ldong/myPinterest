//
//  PictureCollectionViewCell.h
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView* imageView;

-(UIImage *)getRasterizedImageCopy;

-(id)initWithFrame:(CGRect)frame fromUIImage:(UIImage*)image
       atXPosition:(CGFloat) x atYPosition:(CGFloat) y;
@end
