//
//  PictureLineCollectionViewLayout.m
//  MyPinterest
//
//  Created by Lin Dong on 1/12/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import "PictureLineCollectionViewLayout.h"
#import "PictureModel.h"
#import "Utility.h"
#define PICTURE_WIDTH (500)
#define PADDING (10)

@interface PictureLineCollectionViewLayout()

@property (strong, nonatomic) NSMutableArray *pictureModels;

@end

@implementation PictureLineCollectionViewLayout

-(id)init
{
  self = [super init];
  if (self) {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(PICTURE_WIDTH, PICTURE_WIDTH);
    self.sectionInset = UIEdgeInsetsMake(200, 0.0, 200, 0.0);
    self.minimumLineSpacing = 20.0;
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
  
  double y = [UIApplication sharedApplication].statusBarFrame.size.height;
  CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 2*PADDING,
                           [[UIScreen mainScreen] bounds].size.height - 8*PADDING);
  
  for (NSInteger i=0; i< count; ++i){
    originalImage = [(PictureModel*)[[self pictureModels] objectAtIndex:i] originalImage];
    scaledImage = [Utility imageWithImage:originalImage scaledToSize:size];
    
    [(PictureModel*)[[self pictureModels] objectAtIndex:i] setScaledImage:scaledImage];
    [(PictureModel*)[[self pictureModels] objectAtIndex:i] setXPosition:(PADDING + scaledImage.size.width)* i];
    [(PictureModel*)[[self pictureModels] objectAtIndex:i] setYPosition:y];
  }
}


-(CGSize)collectionViewContentSize{
  return CGSizeMake(([[UIScreen mainScreen] bounds].size.width + PADDING) * self.pictureModels.count,
                    [UIScreen mainScreen].bounds.size.height);
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
  
  attributes.size = picModel.scaledImage.size;
  attributes.frame = CGRectMake(picModel.xPosition,
                                picModel.yPosition,
                                picModel.scaledImage.size.width,
                                picModel.scaledImage.size.height);
  
  return attributes;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
  CGRect oldBounds = self.collectionView.bounds;
  if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
    return YES;
  }
  return NO;
}

@end
