//
//  WWAViewController.m
//  WaterWilfred
//
//  Created by Kiara Robles on 10/16/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "WWAViewController.h"
#import "WWAMainViewController.h"
#import "UIColor+ColorWithHex.h"
#import "CALayer+WiggleAnimationAdditions.h"
#import "ACPReminder/ACPReminder.h"
#import "QuartzCore/QuartzCore.h"

@interface WWAViewController ()

@property (strong, nonatomic) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (strong, nonatomic) UIView *swipeLabel;
@property (assign, nonatomic) NSInteger currentExample;
@property (assign, nonatomic) BOOL firstTimeLoading;
@property (assign, nonatomic) CAGradientLayer *gradient;
@property (strong, nonatomic) CAShapeLayer *backgroundLayer;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) CABasicAnimation *fadeIn;
@property (strong, nonatomic) CABasicAnimation *fadeOut;
@property (strong,nonatomic) NSMutableArray *examplesArray;

@end


@implementation WWAViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self firstTimeOpenApp];
    
    self.firstTimeLoading = YES;
    [self setupBackground];
    [self setupGestures];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Views

- (void)firstTimeOpenApp
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasBeenLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasBeenLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [self performSegueWithIdentifier:@"segueToNav" sender:nil];
    }
}
- (void)viewDidLayoutSubviews
{
    if (self.firstTimeLoading)
    {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame];
        
        self.exampleContainerView = [self nextBAFluidViewExample];
        [self.view insertSubview:self.exampleContainerView belowSubview:self.swipeForNextExampleLabel];
        [self.exampleContainerView addGestureRecognizer:self.leftSwipeGestureRecognizer];
        [self.exampleContainerView addGestureRecognizer:self.rightSwipeGestureRecognizer];
        
        self.firstTimeLoading = NO;
    }
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
- (void)setupGestures
{
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    // Setup fading on swipe labels
    self.fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    self.fadeIn.duration = 2.0f;
    self.fadeIn.fromValue = @0.0f;
    self.fadeIn.toValue = @1.0f;
    self.fadeIn.removedOnCompletion = NO;
    self.fadeIn.fillMode = kCAFilterLinear;
    self.fadeIn.additive = NO;
    
    self.fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    self.fadeOut.duration = 2.0f;
    self.fadeOut.fromValue = @1.0f;
    self.fadeOut.toValue = @0.0f;
    self.fadeOut.removedOnCompletion = NO;
    self.fadeOut.fillMode = kCAFilterLinear;
    self.fadeOut.additive = NO;
}


#pragma mark - Gestures

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x - 100.0, self.swipeLabel.frame.origin.y);
        self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
        [self transitionToNextExample];
        
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x + 100.0, self.swipeLabel.frame.origin.y);
        self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
        [self transitionToNextExample];
    }
}


#pragma mark - Actions

-(void)transitionToNextExample{
    [self.animator removeAllBehaviors];
    [self.view.layer removeAllAnimations];
    
    self.currentExample++;
    
    BAFluidView *nextFluidViewExample = [self nextBAFluidViewExample];
    [nextFluidViewExample addGestureRecognizer:self.rightSwipeGestureRecognizer];
    nextFluidViewExample.alpha = 0.0;
    [self.view insertSubview:nextFluidViewExample aboveSubview:self.swipeForNextExampleLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        nextFluidViewExample.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.exampleContainerView removeFromSuperview];
        self.exampleContainerView = nextFluidViewExample;
    }];
    
}


#pragma mark - Animations

- (void) startWiggling
{
    CALayer *wiggleLayer = [self wiggleLayer];
    [wiggleLayer bts_startWiggling];
}

- (void) stopWiggling
{
    CALayer *wiggleLayer= [self wiggleLayer];
    [wiggleLayer bts_stopWiggling];
}

- (CALayer *) wiggleLayer
{
    return [[[[self view] layer] sublayers] lastObject];
}
- (void) runSpinAnimationOnView:(CALayer*)layer duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void) runHalfSpinAnimationOnView:(CALayer*)layer duration:(CGFloat)duration repeat:(float)repeat
{
    NSString *zRotationKeyPath = @"transform.rotation.z";
    
    CGFloat currentAngle = [[layer valueForKeyPath:zRotationKeyPath] floatValue];
    CGFloat angleToAdd   = M_PI;
    [layer setValue:@(currentAngle+angleToAdd) forKeyPath:zRotationKeyPath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:zRotationKeyPath];
    animation.duration = duration;
    animation.toValue = @(0.0);
    animation.byValue = @(angleToAdd);
    animation.repeatCount = repeat;
    
    [layer addAnimation:animation forKey:@"90rotation"];
}
- (void) runBigSpinAnimationOnView:(CALayer*)layer duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat
{
    CGFloat startAngle = - ((float)M_PI / 2);
    CGFloat endAngle = (1.8f * (float)M_PI) + startAngle;
    
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = 1;
    [processBackgroundPath addArcWithCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)
                                     radius:(self.view.bounds.size.width - 1)/2
                                 startAngle:startAngle
                                   endAngle:endAngle
                                  clockwise:YES];
    self.backgroundLayer.path = processBackgroundPath.CGPath;
    
    layer.anchorPoint = CGPointMake(1, 0);
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    [layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(BAFluidView *) nextBAFluidViewExample
{
    switch (self.currentExample)
    {
        case 0:
        {
            // Fill view with water
            self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:@0.55];
            self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
            [self.fluidView keepStationary];
            
            // Set UILabel text
            self.message = [UILabel new];
            self.message.backgroundColor = [UIColor clearColor];
            self.message.text = @"Congrats on your new pet!\nMeet Wilfred.";
            self.message.font = [UIFont fontWithName:@"Helvetica" size:20];
            self.message.numberOfLines = 2;
            self.message.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.message];
            
            // Creating constraints using Layout Anchors
            self.message.translatesAutoresizingMaskIntoConstraints = NO;
            [self.message.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
            [self.message.centerYAnchor constraintEqualToAnchor:self.view.topAnchor constant:100].active = YES;
            [self.message.widthAnchor constraintEqualToConstant:300.0f].active = YES;
            [self.message.heightAnchor constraintEqualToConstant:150.0f].active = YES;
            
            // Initialize first fish images
            self.fishView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 162.9, 120.6)];
            self.fishImage = [UIImage imageNamed:@"Wilfred-Happy"];
            self.fishImageView = [[UIImageView alloc] initWithImage:self.fishImage];
            self.fishImageView.contentMode = UIViewContentModeScaleAspectFit; // Change size
            self.fishImageView.frame = self.fishView.bounds;
            [self.fishView addSubview:self.fishImageView];
            [self.view addSubview:self.fishView];
            
            CGRect viewBounds = [[self view] frame];
            [self.fishImageView.layer setPosition:CGPointMake(viewBounds.size.width / 2.0, viewBounds.size.height / 1.5 - viewBounds.origin.y)];
            [self.fishImageView.layer bts_startWiggling];
            
            // Add breadcrumbs image
            self.breadcrumbsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88.0, 7.0)];
            self.breadcrumbsImage = [UIImage imageNamed:@"page1"];
            self.breadcrumbsImageView = [[UIImageView alloc] initWithImage:self.breadcrumbsImage];
            self.breadcrumbsImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.breadcrumbsImageView.frame = self.breadcrumbsView.bounds;
            [self.view addSubview:self.breadcrumbsImageView];
            [self.view addSubview:self.breadcrumbsView];
            
            CGRect viewBounds2 = [[self view] frame];
            [self.breadcrumbsImageView.layer setPosition:CGPointMake(viewBounds2.size.width / 2.0, viewBounds2.size.height / 1.04 - viewBounds2.origin.y)];
            
            return self.fluidView;
        }
        case 1:
        {
            [self waterLevelAnimationStart:@0.550 fillDuration:3.3 fillTo:@0.250];
            self.message.text = @"Every morning his water\nstarts out low...";
            
            CGPoint originalOrigin = self.fishImageView.frame.origin;
            CGSize originalSize = self.fishImageView.frame.size;
            
            [UIView animateKeyframesWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                              self.fishImageView.frame = CGRectMake(originalOrigin.x,
                                                                                    originalOrigin.y + originalOrigin.y/3.5,
                                                                                    originalSize.width,
                                                                                    originalSize.height);
                self.rightSwipeGestureRecognizer.enabled = NO;
            } completion:^(BOOL finished) {
                self.rightSwipeGestureRecognizer.enabled = YES;
            }];
            
            self.breadcrumbsImageView.image = [UIImage imageNamed:@"page2"];
            
            return self.fluidView;
        }
        case 2:
        {
            [self waterLevelAnimationStart:@0.250 fillDuration:5.0 fillTo:@0.720];
            self.message.text = @"As you drink,\nhis water level rises.";
            
            CGPoint originalOrigin = self.fishImageView.frame.origin;
            CGSize originalSize = self.fishImageView.frame.size;
            
            [UIView animateKeyframesWithDuration:3.5
                                           delay:0
                                         options:UIViewAnimationOptionCurveLinear
                                      animations:^{
                                          
                                          // swim left
                                          [UIView addKeyframeWithRelativeStartTime:0.0
                                                                  relativeDuration:1/4.0
                                                                        animations:^{
                                                                            self.fishImageView.frame = CGRectMake(0,
                                                                                                                  originalOrigin.y - originalOrigin.y/6,
                                                                                                                  originalSize.width,
                                                                                                                  originalSize.height);
                                                                        }];
                                          
                                          // horizontal flip
                                          [UIView addKeyframeWithRelativeStartTime:1/4.0
                                                                  relativeDuration:0.03
                                                                        animations:^{
                                                                            self.fishImageView.layer.transform = CATransform3DMakeScale(-1, 1, 1);
                                                                        }];
                                          
                                          // swim right
                                          [UIView addKeyframeWithRelativeStartTime:1/4.0
                                                                  relativeDuration:2/4.0
                                                                        animations:^{
                                                                            self.fishImageView.frame = CGRectMake(originalOrigin.x * 2,
                                                                                                                  originalOrigin.y - originalOrigin.y/3,
                                                                                                                  originalSize.width,
                                                                                                                  originalSize.height);
                                                                        }];
                                          
                                          // horizontal flip
                                          [UIView addKeyframeWithRelativeStartTime:3/4.0
                                                                  relativeDuration:0.03
                                                                        animations:^{
                                                                            self.fishImageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                                                                        }];
                                          
                                          // swim right
                                          [UIView addKeyframeWithRelativeStartTime:3/4.0
                                                                  relativeDuration:1/4.0
                                                                        animations:^{
                                                                            self.fishImageView.frame = CGRectMake(originalOrigin.x,
                                                                                                                  originalOrigin.y - originalOrigin.y/2,
                                                                                                                  originalSize.width,
                                                                                                                  originalSize.height);
                                          self.rightSwipeGestureRecognizer.enabled = NO;
                                                                        }];
                                          
                                      } completion:^(BOOL finished) {
                                          self.rightSwipeGestureRecognizer.enabled = YES;
                                      }];

            
            CGRect viewBounds = [[self view] frame];
            [self.fishLayer setPosition:CGPointMake(viewBounds.size.width / 2.0, viewBounds.size.height / 1.25 - viewBounds.origin.y)];
            self.breadcrumbsImageView.image = [UIImage imageNamed:@"page3"];
            
            return self.fluidView;
        }
        case 3:
        {
            self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:@0.720];
            self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
            [self.fluidView keepStationary];
            
            self.message.text = @"Give your fish\nmore room to swim!";
            
            CGPoint originalOrigin = self.fishImageView.frame.origin;
            CGSize originalSize = self.fishImageView.frame.size;
            [self.fishLayer setPosition:CGPointMake(originalOrigin.x, originalOrigin.y - originalOrigin.y/2)];
        
            [self runSpinAnimationOnView:self.fishImageView.layer duration:1 rotations:-1 repeat:1];
            
            self.breadcrumbsImageView.image = [UIImage imageNamed:@"page4"];
            
            return self.fluidView;
        }
        case 4:
        {
            [self waterLevelAnimationStart:@0.720 fillDuration:5.0 fillTo:@0.250];
            
            self.message.text = @"But forget to drink water\nand you might end up with\na dead fish.";
            self.message.numberOfLines = 3;
            
            CGPoint originalOrigin = self.fishImageView.frame.origin;
            CGSize originalSize = self.fishImageView.frame.size;
            [UIView animateKeyframesWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.fishImageView.frame = CGRectMake(originalOrigin.x,
                                                      originalOrigin.y + originalOrigin.y,
                                                      originalSize.width,
                                                      originalSize.height);
                [self.fishImageView.layer setContents:(__bridge id)[[UIImage imageNamed:@"Wilfred-DeadFloat.png"] CGImage]];
                [self runHalfSpinAnimationOnView:self.fishImageView.layer duration:1.2 repeat:1];
                
                self.rightSwipeGestureRecognizer.enabled = NO;
            } completion:^(BOOL finished) {
                self.rightSwipeGestureRecognizer.enabled = YES;
            }];
            
            self.breadcrumbsImageView.image = [UIImage imageNamed:@"page5"];
            
            return self.fluidView;
        }
        case 5:
        {
            self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:@0.250];
            self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
            [self.fluidView keepStationary];
            
            self.message.text = @"Wilfed's, just playing!!";
            self.message.numberOfLines = 2;
            
            [self.fishImageView.layer setContents:(__bridge id)[[UIImage imageNamed:@"Wilfred-Happy.png"] CGImage]];
            [self runHalfSpinAnimationOnView:self.fishImageView.layer duration:0.3 repeat:1];
            
            self.breadcrumbsImageView.image = [UIImage imageNamed:@"page6"];
            
            return self.fluidView;
        }
        case 6:
        {
            [self performSegueWithIdentifier:@"segueToNav" sender:nil];
            
            return self.fluidView;
        }
        default:
        {
            self.currentExample = 0;
            return [self nextBAFluidViewExample];
        }
    }
    return nil;
}
- (void) waterLevelAnimationStart:(NSNumber *)startElevation fillDuration:(CGFloat)fillDuration fillTo:(NSNumber *)fillTo
{
    self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:startElevation];
    self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
    self.fluidView.fillDuration = fillDuration;
    self.fluidView.fillRepeatCount = 0.5;
    [self.fluidView fillTo:fillTo];
    [self.fluidView startAnimation];
}

@end