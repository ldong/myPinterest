//
//  Utility.h
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Utility : NSObject
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *)compressImage:(UIImage *)original scale:(CGFloat)scale;
+ (void)setupTabBarButton:(UITabBarItem*)tabBarItem imageName:(NSString*)imageName selectedImageName:(NSString*) selectedImageName scaleToWidth:(CGFloat)width scaleToHeight:(CGFloat)height;

+(UIImage*) makeTabbarImageFromImage:(UIImage*) image;
@end
