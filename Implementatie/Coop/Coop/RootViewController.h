//
//  RootViewController.h
//  Coop
//
//  Created by Sammy Sadati on 17/05/16.
//  Copyright © 2016 Erasmushogeschool Brussel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialContentViewController.h"

@interface RootViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *arrPageTexts;
@property (nonatomic, strong) NSArray *arrPageMainImages;
@property (nonatomic, strong) NSArray *arrPageTabletImage;
@property (nonatomic, strong) NSArray *arrPageLeftHands;
@property (nonatomic, strong) NSArray *arrPageRightHands;

- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index;


@end
