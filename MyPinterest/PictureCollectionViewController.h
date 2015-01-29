//
//  PictureCollectionViewController.h
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureWaterfallCollectionViewLayout.h"
#import "PictureStackCollectionViewLayout.h"
#import "PictureLineCollectionViewLayout.h"

@interface PictureCollectionViewController:UICollectionViewController
<UICollectionViewDelegate, UICollectionViewDataSource,
PictureWaterfallCollectionViewLayoutDelegate, PictureStackCollectionViewLayoutDelegate,
PictureLineCollectionViewLayoutDelegate, UIGestureRecognizerDelegate>

@end
