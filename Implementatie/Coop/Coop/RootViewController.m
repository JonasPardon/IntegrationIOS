//
//  RootViewController.m
//  Coop
//
//  Created by Sammy Sadati on 17/05/16.
//  Copyright © 2016 Erasmushogeschool Brussel. All rights reserved.
//

#import "RootViewController.h"
#import "TAPageControl.h"
#import "TABlueDotView.h"
#import "TAAnimatedDotView.h"

@interface RootViewController () <TAPageControlDelegate> {
    CGRect initialBtnNextPosition;
    CGRect movedBtnNextPosition;
    CGRect initialBtnPrevPosition;
    CGRect movedBtnPrevPosition;
}

@property (strong, nonatomic) TAPageControl *customPageControl;
@property (strong, nonatomic) TAPageControl *customPageControlBlue;

@property (weak, nonatomic) IBOutlet UIImageView *imgBgImage;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnPrev;


@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Content
    self.arrPageTexts = @[@"Test1 ", @"Test 2", @"Test 3", @"Test 4"];
    self.arrPageMainImages = @[@"coop_logo_white", @"personage", @"personage", @"personage"];
    self.arrPageTabletImage = @[@" ", @" ", @"tablet", @" "];
    self.arrPageLeftHands = @[@" ", @"hand-02-left", @"hand-03-left", @"hand-04-left"];
    self.arrPageRightHands = @[@" ", @" ", @"hand-03-right", @"hand-04-right"];
    
    //Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    TutorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers: viewControllers direction: UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    //Change size of tutorial view controller
    self.pageViewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    //Custom page control
    self.customPageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 300, CGRectGetWidth(self.view.frame), 40)];
    self.customPageControl.delegate = self;
    self.customPageControl.numberOfPages = 4;
    [self.view addSubview:self.customPageControl];
    
    self.customPageControlBlue = [[TAPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 300, CGRectGetWidth(self.view.frame), 40)];
    self.customPageControlBlue.delegate = self;
    self.customPageControlBlue.numberOfPages = 4;
    [self.view addSubview:self.customPageControl];
    
    //Set size of bg image bigger for later animation
    self.imgBgImage.transform =CGAffineTransformMakeScale(1.3,1.3);
    
    //Send next & prev button to front
    [self.view addSubview:self.btnNext];
    [self.view addSubview:self.btnPrev];
    [self.view addSubview:self.btnClose];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.btnNext.translatesAutoresizingMaskIntoConstraints = YES;
    initialBtnNextPosition = self.btnNext.frame;
    movedBtnNextPosition = initialBtnNextPosition;
    movedBtnNextPosition.origin.x = movedBtnNextPosition.origin.x + 100;
    
    self.btnPrev.translatesAutoresizingMaskIntoConstraints = YES;
    initialBtnPrevPosition = self.btnPrev.frame;
    movedBtnPrevPosition = initialBtnPrevPosition;
    movedBtnPrevPosition.origin.x = movedBtnPrevPosition.origin.x - 100;
    self.btnPrev.alpha = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = ((TutorialContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    
    if (index == [self.arrPageTexts count])
    {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.arrPageTexts count] == 0) || (index >= [self.arrPageTexts count])) {
        return nil;
        
    }
    // Create a new view controller and transfer data
    TutorialContentViewController *tutorialViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialContentViewController"];
    tutorialViewController.imgMainImageFile = self.arrPageMainImages[index];
    tutorialViewController.tutorialText = self.arrPageTexts[index];
    tutorialViewController.imgTabletFile = self.arrPageTabletImage[index];
    tutorialViewController.imgLeftHandFile = self.arrPageLeftHands[index];
    tutorialViewController.imgRightHandFile = self.arrPageRightHands[index];
    tutorialViewController.pageIndex = index;
    
    return tutorialViewController;
}


- (void)pageViewController:(UIPageViewController *) pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(nonnull NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed){
        [self executeChangesAndAnimations];
    }
}


- (IBAction)nextPage:(id)sender {
    [self changePage:UIPageViewControllerNavigationDirectionForward];
    [self executeChangesAndAnimations];
}

- (IBAction)prevPage:(id)sender {
    [self changePage:UIPageViewControllerNavigationDirectionReverse];
    [self executeChangesAndAnimations];
}

- (IBAction)closeTutorial:(id)sender {
    TutorialContentViewController *tutorialContentViewController =[self.pageViewController.viewControllers lastObject];
    if(tutorialContentViewController.pageIndex == 3) {
        [self changePage:UIPageViewControllerNavigationDirectionReverse];
        [self executeChangesAndAnimations];
    }
}

- (void)changePage:(UIPageViewControllerNavigationDirection)direction {
    //Method from: http://stackoverflow.com/questions/29892018/next-page-button-for-uipageviewcontroller-ios-8-objc
    TutorialContentViewController *tutorialContentViewController =[self.pageViewController.viewControllers lastObject];

    NSUInteger pageIndex = tutorialContentViewController.pageIndex;
    
    if (direction == UIPageViewControllerNavigationDirectionForward) {
        pageIndex++;
    }
    else {
        pageIndex--;
    }
    
    tutorialContentViewController = [self viewControllerAtIndex:pageIndex];
    
    if (tutorialContentViewController == nil) {
        return;
    }
    
    [_pageViewController setViewControllers:@[tutorialContentViewController]
                                  direction:direction
                                   animated:YES
                                 completion:nil];
}

- (void)executeChangesAndAnimations
{
    TutorialContentViewController *tutorialContentViewController =[self.pageViewController.viewControllers lastObject];
    
    self.customPageControl.currentPage = tutorialContentViewController.pageIndex;
    //Transition animations
    
    if(tutorialContentViewController.pageIndex != 0){
        //Change text color
        tutorialContentViewController.lblTutorialText.textColor = [self colorWithHexString:@"444444"];
        [self.btnNext setTitleColor:[self colorWithHexString:@"1cc5ea"] forState:UIControlStateNormal];
        [self.btnClose setTitleColor:[self colorWithHexString:@"1cc5ea"] forState:UIControlStateNormal];
        
        //Hier kleur van pagecontrol veranderen
        self.customPageControl.dotViewClass = [TABlueDotView class];
        
        [UIView animateWithDuration:.5 animations:^{
            //Animate background image
            self.imgBgImage.alpha = 0.0;
        }];
        
        
        //Animate the 'next' buttom, depending on the pageview
        if(tutorialContentViewController.pageIndex == 3) {
            // L A S T   P A G E
            [UIView animateWithDuration:.5 animations:^{
                self.btnNext.frame = initialBtnNextPosition;
                self.btnPrev.frame = initialBtnPrevPosition;
                self.btnPrev.alpha = 0.0;
                
                //Set btn Next to btn Finish
                [self.btnNext setTitle:@"F I N I S H" forState:UIControlStateNormal];
                
                //Set btn close to btn previous
                [self.btnClose setTitle:@"prev" forState:UIControlStateNormal];
            }];
            
            //Rotate right hand of last page
            [UIView animateKeyframesWithDuration:4 delay:1 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
                CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI * - 0.15);
                CGAffineTransform scale = CGAffineTransformMakeScale(1.1, 1.1);
                
                tutorialContentViewController.imgRightHandImage.transform = CGAffineTransformConcat(scale,rotate);
                
            } completion:nil];
            
            //Rotate left hand of last page
            [UIView animateKeyframesWithDuration:4 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
                CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI * 0.15);
                CGAffineTransform scale = CGAffineTransformMakeScale(1.1, 1.1);
                
                tutorialContentViewController.imgLeftHandImage.transform = CGAffineTransformConcat(scale,rotate);
                
            } completion:nil];
            
        } else {
            [UIView animateWithDuration:.5 animations:^{
                self.btnNext.frame = movedBtnNextPosition;
                self.btnPrev.frame = movedBtnPrevPosition;
                self.btnPrev.alpha = 1.0;
                
                //Set btn Next back to default text
                [self.btnNext setTitle:@"N E X T  >" forState:UIControlStateNormal];
                
                //Set btn close back to default text
                [self.btnClose setTitle:@"close" forState:UIControlStateNormal];
            }];
            
            if(tutorialContentViewController.pageIndex == 1) {
                // S E C O N D   P A G E
                [UIView animateKeyframesWithDuration:4 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
                    CGAffineTransform translate = CGAffineTransformMakeTranslation(-10.0, -8.0);
                    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI * - 0.05);
                    CGAffineTransform scale = CGAffineTransformMakeScale(1.1, 1.1);
                    
                    CGAffineTransform concat1 = CGAffineTransformConcat(translate, rotate);
                    
                    tutorialContentViewController.imgLeftHandImage.transform = CGAffineTransformConcat(concat1, scale);
                } completion:nil];
            } else {
                // T H I R D   P A G E
                [UIView animateKeyframesWithDuration:3 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
                    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, -10.0);
                    tutorialContentViewController.imgLeftHandImage.transform = translate;
                } completion:nil];
                
                [UIView animateKeyframesWithDuration:3 delay:.5 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
                    CGAffineTransform translate = CGAffineTransformMakeTranslation(0, -10.0);
                    tutorialContentViewController.imgRightHandImage.transform = translate;
                } completion:nil];
            }
        }
        
    } else {
        
        //Change text color
        tutorialContentViewController.lblTutorialText.textColor = [UIColor whiteColor];
        [self.btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.customPageControl.dotViewClass = [TAAnimatedDotView class];
        //Animate background image
        
        [UIView animateWithDuration:.5 animations:^{
            self.imgBgImage.alpha = 1.0;
            self.imgBgImage.transform = CGAffineTransformMakeScale(1.3,1.3);
            
            //Animate btn back
            self.btnNext.frame = initialBtnNextPosition;
            self.btnPrev.frame = initialBtnPrevPosition;
            self.btnPrev.alpha = 0.0;
        }];
    }
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    //Method taken from http://stackoverflow.com/questions/6207329/how-to-set-hex-color-code-for-background
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
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

//Code based on http://www.theappguruz.com/blog/uipageviewcontroller-in-ios#sthash.M2sh0fdK.dpuf
