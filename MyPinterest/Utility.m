//
//  Utility.m
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
  UIGraphicsBeginImageContext( newSize );
  [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

+ (UIImage *)compressImage:(UIImage *)original scale:(CGFloat)scale
{
  // Calculate new size given scale factor.
  CGSize originalSize = original.size;
  CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
  
  // Scale the original image to match the new size.
  UIGraphicsBeginImageContext(newSize);
  [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return compressedImage;
}

+ (void)setupTabBarButton:(UITabBarItem*)tabBarItem imageName:(NSString*)imageName selectedImageName:(NSString*) selectedImageName scaleToWidth:(CGFloat)width scaleToHeight:(CGFloat)height{
  //update tabbar images
  UIImage * tabBarImage = [UIImage imageNamed:imageName];
  tabBarItem.image = [[self imageWithImage:tabBarImage scaledToSize:CGSizeMake(width, height)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  
  UIImage * tabBarSelectedImage = [UIImage imageNamed:selectedImageName];
  tabBarItem.selectedImage = [[self imageWithImage:tabBarSelectedImage scaledToSize:CGSizeMake(width, height)]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


+(UIImage*) makeTabbarImageFromImage:(UIImage*) originalImage{
  double scale = originalImage.size.width / 44;
  NSLog(@"Scale: %f",scale);
  UIImage *scaledImage = [UIImage imageWithCGImage:[originalImage CGImage]
                                             scale:scale orientation:(originalImage.imageOrientation)];
  return scaledImage;
}



@end
