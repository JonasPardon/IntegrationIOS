//
//  TutorialContentViewController.m
//  Coop
//
//  Created by Sammy Sadati on 17/05/16.
//  Copyright © 2016 Erasmushogeschool Brussel. All rights reserved.
//

#import "TutorialContentViewController.h"

@interface TutorialContentViewController ()

@end

@implementation TutorialContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgMainImage.image = [UIImage imageNamed: self.imgMainImageFile];
    self.lblTutorialText.text = self.tutorialText;
    self.imgTablet.image = [UIImage imageNamed:self.imgTabletFile];
    self.imgLeftHandImage.image = [UIImage imageNamed:self.imgLeftHandFile];
    self.imgRightHandImage.image = [UIImage imageNamed:self.imgRightHandFile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
