//
//  PictureCollectionViewCell.m
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import "PictureCollectionViewCell.h"
#define IMAGEVIEW_BORDER_LENGTH 5

@implementation PictureCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  
  return self;
}


- (void)setup {
  NSLog(@"PictureCollectionViewCell setup");
  self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, IMAGEVIEW_BORDER_LENGTH, IMAGEVIEW_BORDER_LENGTH)];
  self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.contentView addSubview:self.imageView];
  
}

-(id)initWithFrame:(CGRect)frame fromUIImage:(UIImage*)image
       atXPosition:(CGFloat) x atYPosition:(CGFloat) y {
  NSLog(@"PictureCollectionViewCell init");
  if (!(self = [super initWithFrame:frame])) {
    return nil;
  }
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, image.size.width, image.size.height)];
  [self setImageView:imageView];
  [[self contentView] addSubview:[self imageView]];
  return self;
}


-(UIImage *)getRasterizedImageCopy {
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
  [self.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

@end
