//
//  LocalPictureViewController.m
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import "LocalPictureViewController.h"
#import "Utility.h"

@interface LocalPictureViewController ()

@end

@implementation LocalPictureViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (id)init {
  if (!(self = [super init]))
  {
    return nil;
  }
  
  [self setUp];
  [self setUpViewControllerInsideOfLocalPictureViewController];
  return self;
  
}

-(void) setUp {
  NSLog(@"Setting up from LocalPictureViewController");
  [self setTitle:@"Local"];
  //  UITabBarItem *item =[[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
  UIImage *originalImage = [UIImage imageNamed:@"local.png"];
  UIImage *scaledImage = [Utility makeTabbarImageFromImage:originalImage];
  UITabBarItem *item =[[UITabBarItem alloc]initWithTitle:@"" image:scaledImage selectedImage:scaledImage];
  [self setTabBarItem:item];
}

-(void) setUpViewControllerInsideOfLocalPictureViewController{
  NSLog(@"Setting up from ControllerInsideOfLocalPictureViewController");
  PictureCollectionViewController *pictureCollectionViewController = [[PictureCollectionViewController alloc]init];
  [self setPictureCollectionViewController:pictureCollectionViewController];
}


@end
