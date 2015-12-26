//
//  WWAManagerViewController.m
//  WaterWilfred
//
//  Created by Kiara Robles on 12/25/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "WWAManagerViewController.h"
#import "UIColor+ColorWithHex.h"

@interface WWAManagerViewController ( )

@property (assign, nonatomic) CAGradientLayer *gradient;
@property (strong, nonatomic) CAShapeLayer *backgroundLayer;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation WWAManagerViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackground];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [self performSelector:@selector(showFirstLoad) withObject:nil afterDelay:0];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [self performSelector:@selector(showMainView) withObject:nil afterDelay:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showFirstLoad
{
    [self performSegueWithIdentifier:@"showFirstLoad" sender:self];
}
- (void)showMainView
{
    [self performSegueWithIdentifier:@"showMainView" sender:self];
}

- (void)setupBackground
{
    // Setup gradient
    if (self.gradient)
    {
        [self.gradient removeFromSuperlayer];
        self.gradient = nil;
    }
    
    // Resetting a gradient layer, causes the iphone6 simulator to fail (weird bug)
    CAGradientLayer *tempLayer = [CAGradientLayer layer];
    tempLayer.frame = self.view.bounds;
    tempLayer.colors = @[(id)[UIColor colorWithHex:0x53cf84].CGColor,
                         (id)[UIColor colorWithHex:0x53cf84].CGColor,
                         (id)[UIColor colorWithHex:0x2aa581].CGColor,
                         (id)[UIColor colorWithHex:0x1b9680].CGColor];
    tempLayer.locations = @[[NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f]];
    tempLayer.startPoint = CGPointMake(0, 0);
    tempLayer.endPoint = CGPointMake(1, 1);
    self.gradient = tempLayer;
    
    [self.backgroundView.layer insertSublayer:self.gradient atIndex:0];
}


@end
