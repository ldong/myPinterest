//
//  ViewController.m
//  MyPinterest
//
//  Created by Lin Dong on 1/11/15.
//  Copyright (c) 2015 Lin Dong. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "LocalPictureViewController.h"
#import "PictureCollectionViewController.h"


@interface MainTabbarViewController ()
@end

@implementation MainTabbarViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self setUpApp];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(id) init{
  if (!(self = [super init])){
    return nil;
  }
  
  return self;
}

-(void) setUpApp{
  NSLog(@"Setting up App");
  [self setUpTabViewController];
}

#pragma mark -setUpTabViewController
-(void) setUpTabViewController{
  NSLog(@"Setting up TabViewController");
  PictureCollectionViewController *pictureCollectionViewController = [[PictureCollectionViewController alloc] init];
  NSArray *array = [[NSArray alloc] initWithObjects:pictureCollectionViewController, nil];
  [self setViewControllers:array];
}




@end
