//
//  PictureLineCollectionViewLayout.h
//  MyPinterest
//
//  Created by Lin Dong on 1/12/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureLineCollectionViewLayoutDelegate <UICollectionViewDelegate>

-(NSMutableArray*) getPictureModels;

@end

@interface PictureLineCollectionViewLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) id <PictureLineCollectionViewLayoutDelegate> delegate;

@end
