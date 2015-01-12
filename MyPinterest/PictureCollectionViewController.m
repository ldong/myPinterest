//
//  PictureCollectionViewController.m
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import "PictureCollectionViewController.h"
#import "PictureWaterfallCollectionViewLayout.h"
#import "PictureCollectionViewCell.h"
#import "PictureModel.h"
#import "PictureStackCollectionViewLayout.h"
#import "Utility.h"

@interface PictureCollectionViewController()

@property (strong, nonatomic) NSMutableArray *pictureModels;
@property (strong, nonatomic) PictureWaterfallCollectionViewLayout* PictureWaterfallCollectionViewLayout;

@property (strong, nonatomic) NSIndexPath *gestureBeginIndex;
@property (strong, nonatomic) NSIndexPath *gestureEndIndex;
@property (nonatomic) UIImageView *draggingView;
@property (nonatomic) CGPoint dragViewStartLocation;
@end


@implementation PictureCollectionViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@"viewDidLoad from PictureCollectionViewController");
  [self.collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
  
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (id)init {
  PictureWaterfallCollectionViewLayout *layout = [[PictureWaterfallCollectionViewLayout alloc] init];
  layout.delegate = self;
  //  [layout setDelegate:self];
  
  if (!(self = [super initWithCollectionViewLayout:layout])) {
    return nil;
  }
  
  [self setUp];
  NSString *folderName = @"pics";
  [self getUIImageArrayFromBundle:folderName];
  [self setPictureWaterfallCollectionViewLayout:layout];
  return self;
}


-(NSMutableArray *)pictureModels{
  if (!_pictureModels) {
    _pictureModels = [[NSMutableArray alloc] initWithObjects: nil];
  }
  return _pictureModels;
}

-(void) setUp {
  NSLog(@"Setting up from PictureCollectionViewController");
  //  [self.collectionView registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
  [self setTitle:@"PictureCollectionViewController"];
  [[self collectionView] setBackgroundColor:[UIColor whiteColor]];
  //  UITabBarItem *item =[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
  UIImage *originalImage = [UIImage imageNamed:@"local.png"];
  UIImage *scaledImage = [Utility makeTabbarImageFromImage:originalImage];
  UITabBarItem *item =[[UITabBarItem alloc]initWithTitle:@"" image:scaledImage selectedImage:scaledImage];
  [self setTabBarItem:item];
  [self configureGestureRecognizers];
}

-(void) configureGestureRecognizers {
  UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector
                                            (pinchGesture:)];
  [self.view addGestureRecognizer:pinchGesture];
  
  UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector
                                              (doubleTapGestureGesture:)];
  doubleTapGesture.numberOfTapsRequired = 2;
  [self.view addGestureRecognizer:doubleTapGesture];
  
  UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(handleLongPressGesture:)];
  longPressGesture.minimumPressDuration = .5; //seconds
  longPressGesture.delegate = self;
  //  [self.collectionView addGestureRecognizer:longPressGesture];
  [self.view addGestureRecognizer:longPressGesture];
  
  
  UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
  refreshControl.backgroundColor = [UIColor lightGrayColor];
  refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Downloading ..."];
  [refreshControl addTarget:self action:@selector(refreshControlGesture:) forControlEvents:UIControlEventValueChanged];
  [self.collectionView addSubview:refreshControl];
  self.collectionView.alwaysBounceVertical = YES;
}

-(void) refreshControlGesture: (UIRefreshControl*) sender{
  [sender beginRefreshing];
  NSURL *url = [NSURL URLWithString:@"https://ppcdn.500px.org/4357365/9c00314413f0058f0abe2fe22aa6c7ca7e48e5d3/2048.jpg"];
  [self fetchPictureFromInternetURL:url];
  [sender endRefreshing];
}

-(void) fetchPictureFromInternetURL: (NSURL*) url{
  dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, NULL);
  dispatch_async(downloadQueue, ^{
    NSData * imageData = [NSData dataWithContentsOfURL:url];
    
    dispatch_async(dispatch_get_main_queue(),^{
      UIImage *image = [UIImage imageWithData:imageData];
      PictureModel *model = [[PictureModel alloc]init:image];
      [[self pictureModels] addObject:model];
      [self.collectionView reloadData];
    });
  });
}


- (void)doubleTapGestureGesture:(UIPinchGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateRecognized) {
    [self.collectionView setCollectionViewLayout:self.PictureWaterfallCollectionViewLayout animated:YES];
    PictureLineCollectionViewLayout *layout = [[PictureLineCollectionViewLayout alloc] init];
    layout.delegate = self;
    [self.collectionView setCollectionViewLayout:layout animated:YES];
  }
}


- (void)pinchGesture:(UIPinchGestureRecognizer *)sender {
  NSLog(@"UIPinchGestureRecognizer worked");
  if([sender state] == UIGestureRecognizerStateEnded){
    if([self.collectionView.collectionViewLayout isKindOfClass:[PictureWaterfallCollectionViewLayout class]]
       && [sender scale] < 1 ){
      PictureStackCollectionViewLayout *layout = [[PictureStackCollectionViewLayout alloc] init];
      layout.delegate = self;
      [self.collectionView setCollectionViewLayout:layout animated:YES];
    } else if(([self.collectionView.collectionViewLayout isKindOfClass:[PictureStackCollectionViewLayout class]]
               && [sender scale] > 1)){
      PictureWaterfallCollectionViewLayout *layout = [[PictureWaterfallCollectionViewLayout alloc] init];
      layout.delegate = self;
      [self.collectionView setCollectionViewLayout:layout animated:YES];
    } else if([self.collectionView.collectionViewLayout isKindOfClass:[PictureLineCollectionViewLayout class]]
              && [sender scale] < 1){
      PictureStackCollectionViewLayout *layout = [[PictureStackCollectionViewLayout alloc] init];
      layout.delegate = self;
      [self.collectionView setCollectionViewLayout:layout animated:YES completion:^(BOOL finished) {
        PictureWaterfallCollectionViewLayout *layout2 = [[PictureWaterfallCollectionViewLayout alloc] init];
        layout2.delegate = self;
        [self.collectionView setCollectionViewLayout:layout2 animated:YES];
      }];
    }
  }
}

-(void) getUIImageArrayFromBundle: (NSString*) folderName {
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *bundlePath = [bundle resourcePath];
  NSString *folderPath = [bundlePath stringByAppendingPathComponent:folderName];
  NSFileManager *fileManager =  [NSFileManager defaultManager];
  NSArray *picNames = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
  for (int i=0; i<[picNames count]; ++i) {
    NSString *picPath = [NSString stringWithFormat:@"%@/%@",folderPath, picNames[i]];
    UIImage *image = [UIImage imageWithContentsOfFile:picPath];
    if(image){
      PictureModel* pictureModel = [[PictureModel alloc]init:image];
      [self.pictureModels addObject:pictureModel];
    }
  }
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration{
  [self.collectionView.collectionViewLayout invalidateLayout];
}


#pragma mark <PictureCollectionViewDelegate>

-(NSMutableArray*) getPictureModels{
  return [self pictureModels];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [[self pictureModels] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  // Configure the cell
  PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  
  cell.imageView.image = [((PictureModel*)[[self pictureModels] objectAtIndex:indexPath.row]) scaledImage];
  return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  PictureCollectionViewCell* cell = (PictureCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  [UIView animateWithDuration:0.3
                        delay:0
                      options:(UIViewAnimationOptionAllowUserInteraction)
                   animations:^{
                     [cell setBackgroundColor:[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:0.7]];
                   }
                   completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
  PictureCollectionViewCell* cell = (PictureCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  [UIView animateWithDuration:0.3
                        delay:0
                      options:(UIViewAnimationOptionAllowUserInteraction)
                   animations:^{
                     [cell setBackgroundColor:[UIColor clearColor]];
                   }
                   completion:nil ];
}

// dragable
- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)sender {
  if ([self.collectionView.collectionViewLayout isKindOfClass:[PictureWaterfallCollectionViewLayout class]]) {
    NSLog(@"class Name: %@", [self.collectionViewLayout class]);
    CGPoint loc = [sender locationInView:self.collectionView];
    
    CGFloat heightInScreen = fmodf((loc.y-self.collectionView.contentOffset.y), CGRectGetHeight(self.collectionView.frame));
    CGPoint locInScreen = CGPointMake( loc.x-self.collectionView.contentOffset.x, heightInScreen );
    
    if (sender.state == UIGestureRecognizerStateBegan) {
      self.gestureBeginIndex = [self.collectionView indexPathForItemAtPoint:loc];
      
      if (self.gestureBeginIndex) {
        PictureCollectionViewCell *cell = (PictureCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.gestureBeginIndex];
        self.draggingView = [[UIImageView alloc] initWithImage:[cell getRasterizedImageCopy]];
        
        [cell.contentView setAlpha:0.f];
        [self.view addSubview:self.draggingView];
        self.draggingView.center = locInScreen;
        self.dragViewStartLocation = self.draggingView.center;
        [self.view bringSubviewToFront:self.draggingView];
        
        [UIView animateWithDuration:.4f animations:^{
          CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
          self.draggingView.transform = transform;
        }];
      }
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
      self.draggingView.center = locInScreen;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
      if (self.draggingView) {
        self.gestureEndIndex = [self.collectionView indexPathForItemAtPoint:loc];
        if (self.gestureEndIndex) {
          //update date source
          NSNumber *thisNumber = [self.pictureModels objectAtIndex:self.gestureBeginIndex.row];
          [self.pictureModels removeObjectAtIndex:self.gestureBeginIndex.row];
          
          if (self.gestureEndIndex.row < self.gestureBeginIndex.row) {
            [self.pictureModels insertObject:thisNumber atIndex:self.gestureEndIndex.row];
          } else {
            [self.pictureModels insertObject:thisNumber atIndex:self.gestureEndIndex.row];
          }
          
          [UIView animateWithDuration:.4f animations:^{
            self.draggingView.transform = CGAffineTransformIdentity;
          } completion:^(BOOL finished) {
            
            
            
            //change items
            __weak typeof(self) weakSelf = self;
            [self.collectionView performBatchUpdates:^{
              __strong typeof(self) strongSelf = weakSelf;
              if (strongSelf) {
                
                [strongSelf.collectionView deleteItemsAtIndexPaths:@[ self.gestureBeginIndex ]];
                [strongSelf.collectionView insertItemsAtIndexPaths:@[ strongSelf.gestureEndIndex ]];
              }
            } completion:^(BOOL finished) {
              PictureCollectionViewCell *movedCell = (PictureCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.gestureEndIndex];
              [movedCell.contentView setAlpha:1.f];
              
              PictureCollectionViewCell *oldIndexCell = (PictureCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.gestureBeginIndex];
              [oldIndexCell.contentView setAlpha:1.f];
            }];
            
            [self.draggingView removeFromSuperview];
            self.draggingView = nil;
            self.gestureBeginIndex = nil;
            
          }];
          
        } else {
          [UIView animateWithDuration:.4f animations:^{
            self.draggingView.transform = CGAffineTransformIdentity;
          } completion:^(BOOL finished) {
            PictureCollectionViewCell *cell = (PictureCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:self.gestureBeginIndex];
            [cell.contentView setAlpha:1.f];
            
            [self.draggingView removeFromSuperview];
            self.draggingView = nil;
            self.gestureBeginIndex = nil;
          }];
        }
        
        loc = CGPointZero;
      }
    }
  }
}

@end
