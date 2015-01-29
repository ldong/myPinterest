//
//  PictureStackCollectionViewLayout.h
//  MyPinterest
//
//  Created by Lin Dong on 1/12/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureStackCollectionViewLayoutDelegate <UICollectionViewDelegate>

-(NSMutableArray*) getPictureModels;

@end

@interface PictureStackCollectionViewLayout : UICollectionViewLayout

@property (weak, nonatomic) id <PictureStackCollectionViewLayoutDelegate> delegate;

@end
