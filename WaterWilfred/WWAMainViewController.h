//
//  WWAMainViewController.h
//  WaterWilfred
//
//  Created by Kiara Robles on 11/7/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFluidView.h"

@interface WWAMainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *swipeForNextExampleLabel;
@property (strong, nonatomic) IBOutlet UIView *exampleContainerView;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UIView *fishView;
@property (nonatomic, strong) UIImage *fishImage;
@property (nonatomic, strong) UIImageView *fishImageView;
@property (strong, nonatomic) BAFluidView *fluidView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)plusButton:(UIBarButtonItem *)sender;
- (IBAction)minusButton:(UIBarButtonItem *)sender;

@end
