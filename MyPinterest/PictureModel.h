//
//  PictureModel.h
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PictureModel : NSObject

@property UIImage* originalImage;
@property UIImage* scaledImage;
@property CGFloat xPosition;
@property CGFloat yPosition;

-(id)init: (UIImage*) originalImage;

@end
