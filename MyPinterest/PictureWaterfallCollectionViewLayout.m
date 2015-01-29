//
//  PictureWaterfallCollectionViewLayout.m
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import "PictureWaterfallCollectionViewLayout.h"
#import "PictureModel.h"


#define NUMBER_OF_COLUMN 3

@interface PictureWaterfallCollectionViewLayout()

@property CGFloat viewWidth;
@property CGFloat viewHeight;
@property (strong, nonatomic) NSMutableArray *pictureModels;

@end


@implementation PictureWaterfallCollectionViewLayout

-(id)init {
  NSLog(@"Setting up from PictureWaterfallCollectionViewLayout");
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
  NSLog(@"Calculate sizes");
  double screenWidth = [[UIScreen mainScreen] bounds].size.width;
  NSLog(@"screen width: %f", screenWidth);
  /*
   double columnWidth = (screenWidth/ NUMBER_OF_COLUMN)-10;
   NSLog(@"column width: %f", columnWidth);
   */
  int numberOfColumn = 3;
  double columnWidth = (screenWidth/ numberOfColumn)-10;
  NSLog(@"column width: %f", columnWidth);
  
  // Just right below the status bar
  double col0Height = [UIApplication sharedApplication].statusBarFrame.size.height;
  double col1Height = col0Height;
  double col2Height = col0Height;
  double padding = 5;
  int x=0, y=0;
  NSInteger count = [[self pictureModels] count];
  UIImage *originalImage;
  UIImage *scaledImage;
  for (NSInteger i=0; i< count; ++i){
    originalImage = [(PictureModel*)[[self pictureModels] objectAtIndex:i] originalImage];
    double scale = originalImage.size.width / columnWidth;
    scaledImage = [UIImage imageWithCGImage:[originalImage CGImage]
                                      scale:scale orientation:(originalImage.imageOrientation)];
    if(col0Height <= col1Height && col0Height <= col2Height){
      //      NSLog(@"1st col");
      y = col0Height;
      x = columnWidth * 0 + padding;
      col0Height += scaledImage.size.height + padding;
    } else if ( col1Height <= col0Height && col1Height <= col2Height) {
      //      NSLog(@"2nd col");
      y = col1Height;
      x = columnWidth * 1 + padding * 2;
      col1Height += scaledImage.size.height + padding;
    } else if( col2Height <= col0Height && col2Height <= col1Height){
      //      NSLog(@"3rd col");
      y = col2Height;
      x = columnWidth * 2 + padding * 4;
      col2Height += scaledImage.size.height + padding;
    } else {
      NSLog(@"something went wrong: col0: %f, col1: %f, col2: %f", col0Height, col1Height, col2Height);
    }
    
    [(PictureModel*)[[self pictureModels] objectAtIndex:i] setScaledImage:scaledImage];
    [(PictureModel*)[[self pictureModels] objectAtIndex:i] setXPosition:x];
    [(PictureModel*)[[self pictureModels] objectAtIndex:i] setYPosition:y];
  }
  [self setViewHeight:y+scaledImage.size.height+padding];
  [self setViewWidth: screenWidth];
}


- (void)invalidateLayout{
  [super invalidateLayout];
  NSLog(@"- (void)invalidateLayout");
}

-(CGSize)collectionViewContentSize{
  return CGSizeMake([self viewWidth], [self viewHeight]);
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
