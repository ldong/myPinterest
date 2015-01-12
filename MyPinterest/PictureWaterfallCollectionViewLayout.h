//
//  PictureWaterfallCollectionViewLayout.h
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureWaterfallCollectionViewLayoutDelegate <UICollectionViewDelegate>

-(NSMutableArray*) getPictureModels;

@end

@interface PictureWaterfallCollectionViewLayout : UICollectionViewLayout

@property (weak, nonatomic) id <PictureWaterfallCollectionViewLayoutDelegate> delegate;

@end
