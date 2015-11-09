//
//  WWAViewController.h
//  WaterWilfred
//
//  Created by Kiara Robles on 10/16/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFluidView.h"

@interface WWAViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *swipeForNextExampleLabel;
@property (strong, nonatomic) IBOutlet UIView *exampleContainerView;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic, strong) UIImageView *myImageView;
@property (strong, nonatomic) UILabel *message;
@property (nonatomic, strong) UIView *fishView;
@property (strong, nonatomic) CALayer *fishLayer;
@property (strong, nonatomic) CALayer *fishLargerLayer;
@property (nonatomic, strong) UIView *breadcrumbsView;
@property (strong, nonatomic) CALayer *breadcrumbsLayer;
@property (strong, nonatomic) BAFluidView *fluidView;

@end
