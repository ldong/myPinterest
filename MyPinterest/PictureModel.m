//
//  PictureModel.m
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import "PictureModel.h"

@implementation PictureModel

-(id)init: (UIImage*) originalImage{
  
  if(!(self = [super init])){
    return nil;
  }
  
  [self setOriginalImage:originalImage];
  return self;
}

@end
