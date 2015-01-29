//
//  PictureStackCollectionViewLayout.m
//  MyPinterest
//
//  Created by Lin Dong on 1/12/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import "PictureStackCollectionViewLayout.h"
#import "PictureModel.h"
#define PICTURE_WIDTH (500)

@interface PictureStackCollectionViewLayout()
@property (strong, nonatomic) NSMutableArray *pictureModels;
@end

@implementation PictureStackCollectionViewLayout


-(id)init {
  NSLog(@"Setting up from PictureStackCollectionViewLayout");
  if(!(self = [super init])){
    return nil;
  }
  
  return self;
}


-(void)prepareLayout{
  [self setPictureModels:[[self delegate] getPictureModels]];
  [self calculateSizes];
}

-(void)calculateSizes{
  NSInteger count = [[self pictureModels] count];
  UIImage *originalImage;
  UIImage *scaledImage;
  for (NSInteger i=0; i< count; ++i){
    originalImage = [(PictureModel*)[[self pictureModels] objectAtIndex:i] originalImage];
    double scale = originalImage.size.width / PICTURE_WIDTH;
    scaledImage = [UIImage imageWithCGImage:[originalImage CGImage]
                                      scale:scale orientation:(originalImage.imageOrientation)];
    [(PictureModel*)[[self pictureModels] objectAtIndex:i] setScaledImage:scaledImage];
  }
}


-(CGSize)collectionViewContentSize{
  return [UIScreen mainScreen].bounds.size;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
  NSMutableArray* attributes = [NSMutableArray array];
  NSInteger count = [[self pictureModels] count];
  for(NSInteger i=0; i < count; ++i){
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
    [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
  }
  
  return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
  PictureModel* picModel = (PictureModel*)[[self pictureModels] objectAtIndex:indexPath.row];
  
//  attributes.size = picModel.scaledImage.size;
  double width = [UIScreen mainScreen].bounds.size.width/3.f*2.f;
  attributes.size = CGSizeMake(width,width);
  
  attributes.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
  attributes.zIndex = indexPath.row;
  CGAffineTransform transform = CGAffineTransformMakeRotation(4 -(arc4random()%4));
  attributes.transform = transform;
  
  return attributes;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
  // TODO
  CGRect oldBounds = self.collectionView.bounds;
  if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
    return YES;
  }
  return NO;
}

@end
