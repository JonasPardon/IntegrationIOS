//
//  TutorialContentViewController.h
//  Coop
//
//  Created by Sammy Sadati on 17/05/16.
//  Copyright © 2016 Erasmushogeschool Brussel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgMainImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTutorialText;
@property (weak, nonatomic) IBOutlet UIImageView *imgTablet;
@property (weak, nonatomic) IBOutlet UIImageView *imgLeftHandImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgRightHandImage;


@property NSUInteger pageIndex;
@property NSString *imgMainImageFile;
@property NSString *tutorialText;
@property NSString *imgTabletFile;
@property NSString *imgLeftHandFile;
@property NSString *imgRightHandFile;

@end
