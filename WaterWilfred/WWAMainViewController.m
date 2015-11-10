//
//  WWAMainViewController.m
//  WaterWilfred
//
//  Created by Kiara Robles on 11/7/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "WWAMainViewController.h"
#import "WWAViewController.h"
#import "UIColor+ColorWithHex.h"
#import "CALayer+WiggleAnimationAdditions.h"
#import "ACPReminder/ACPReminder.h"
#import "UIView+AnimationExtensions.h"

@interface WWAMainViewController ()

@property (strong, nonatomic) UISwipeGestureRecognizer *downSwipeGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *upSwipeGestureRecognizer;
@property (strong, nonatomic) UIView *swipeLabel;
@property (assign, nonatomic) NSInteger currentWaterLevel;
@property (assign, nonatomic) BOOL firstTimeLoading;
@property (assign, nonatomic) CAGradientLayer *gradient;
@property (strong, nonatomic) CAShapeLayer *backgroundLayer;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) CABasicAnimation *fadeIn;
@property (strong, nonatomic) CABasicAnimation *fadeOut;
@property (nonatomic) NSUInteger currentGlassesCount;
@property (strong, nonatomic) NSString *currentGlassesCountString;
@property (nonatomic, strong) NSString *valuePassed;
@property (nonatomic, strong) NSMutableArray *sequenceOfAnimations;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSUserDefaults *theDefaults;

@end

@implementation WWAMainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstTimeLoading = YES;
    [self setupBackground];
    [self setupNavigationController];
    [self setupTitle];
    [self setupGestures];
    [self checkLaunch];
    
    // [self presentWeightInputAlert];
    
    NSLog(@"Viw loading?????");
}
- (void) viewDidAppear {
    [self.fishImageView.layer bts_startWiggling];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void) checkLaunch {
    NSUInteger launchCount;
    //Set up the properties for the integer and default.
    self.theDefaults = [NSUserDefaults standardUserDefaults];
    launchCount = [self.theDefaults integerForKey:@"hasRun"] + 1;
    [self.theDefaults setInteger:launchCount forKey:@"hasRun"];
    [self.theDefaults synchronize];
    
    //Log the amount of times the application has been run
    NSLog(@"This application has been run %lu amount of times", (unsigned long)launchCount);
    
    //Test if application is the first time running
    if(launchCount == 1) {
        //Run your first launch code (Bring user to info/setup screen, etc.)
        NSLog(@"This is the first time this application has been run");
        //[self performSegueWithIdentifier:@"segueToNavOnce" sender:nil];
    }
              
    //Test if it has been run before
    if(launchCount >= 2) {
        //Run new code if they have opened the app before (Bring user to home screen etc.
        NSLog(@"This application has been run before");
    }
}

#pragma mark - Views

- (void)viewDidLayoutSubviews
{
    if (self.firstTimeLoading)
    {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame];
        self.currentWaterLevel = 0;
        self.sequenceOfAnimations = [NSMutableArray new];
        
        self.exampleContainerView = [self nextBAFluidViewExample];
        [self.view insertSubview:self.exampleContainerView belowSubview:self.swipeForNextExampleLabel];
        
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
- (void)setupNavigationController
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName:
                                                                           [UIFont fontWithName:@"HelveticaNeue-Bold"
                                                                                           size:16.0f],
                                                                       NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    // Make Navigation controller completely clear
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)setupTitle
{
    self.currentGlassesCountString = [NSString stringWithFormat:@"%lu", (long)self.currentGlassesCount];
    NSString *totalGlassesCount = @"/8";
    NSString *title = [self.currentGlassesCountString stringByAppendingString:totalGlassesCount];
    
    self.title = title;
}
- (void)setupGestures
{
    self.downSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.upSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.downSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    self.upSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:self.downSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.upSwipeGestureRecognizer];
    
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
    if (sender.direction == UISwipeGestureRecognizerDirectionDown)
    {
        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x - 100.0, self.swipeLabel.frame.origin.y);
        self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
        self.currentGlassesCount -= 1;
        self.currentWaterLevel -= 1;
        [self setupTitle];
        [self transitionToNextExample];
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionUp)
    {
        CGPoint labelPosition = CGPointMake(self.swipeLabel.frame.origin.x + 100.0, self.swipeLabel.frame.origin.y);
        self.swipeLabel.frame = CGRectMake( labelPosition.x , labelPosition.y , self.swipeLabel.frame.size.width, self.swipeLabel.frame.size.height);
        self.currentGlassesCount += 1;
        self.currentWaterLevel += 1;
        [self setupTitle];
        [self transitionToNextExample];
    }
}


#pragma mark - Actions

-(void) presentWeightInputAlert
{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Enter Your Weight"
                                message:@" "
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *submit = [UIAlertAction
                             actionWithTitle:@"Submit"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action)
                             {
                                 UITextField *alertField = [alert.textFields firstObject];
                                 self.valuePassed = alertField.text;
                                 NSCharacterSet *validCharacter = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
                                 NSCharacterSet *invalidset = [validCharacter invertedSet];
                                 NSRange invalidCharacterRange = [alertField.text rangeOfCharacterFromSet:invalidset];
                                 
                                 if(invalidCharacterRange.length == 0 && alertField.text.length >= 1)
                                 {
                                     //[self performSegueWithIdentifier:@"numberOfCells" sender:submit];
                                 }
                                 else
                                 {
                                     UIAlertController *invalidEntryAlert = [UIAlertController
                                                                             alertControllerWithTitle:@"Alert"
                                                                             message:@"Invalid Entry"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *ok = [UIAlertAction
                                                          actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action)
                                                          {
                                                              [self presentWeightInputAlert];
                                                          }];
                                     [invalidEntryAlert addAction:ok];
                                     
                                     [self presentViewController:invalidEntryAlert animated:YES completion:nil];
                                 }
                             }];
    
    [alert addAction:submit];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *userInputTextField)
     {
         userInputTextField.placeholder = @" Weight in lbs";
         userInputTextField.keyboardType = UIKeyboardTypeDefault;
     }];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)plusButton:(UIBarButtonItem *)sender
{
    self.currentGlassesCount += 1;
    self.currentWaterLevel += 1;
    [self setupTitle];
    [self transitionToNextExample];
}


#pragma mark - Animations


- (void)startWiggling
{
    CALayer *wiggleLayer = [self wiggleLayer];
    [wiggleLayer bts_startWiggling];
}
- (void)stopWiggling
{
    CALayer *wiggleLayer= [self wiggleLayer];
    [wiggleLayer bts_stopWiggling];
}
- (CALayer *)wiggleLayer
{
    return [[[[self view] layer] sublayers] lastObject];
}
-(void) transitionToNextExample
{
    [self.animator removeAllBehaviors];
    
    // Show next animation
    BAFluidView *nextFluidViewExample = [self nextBAFluidViewExample];
    [nextFluidViewExample addGestureRecognizer:self.upSwipeGestureRecognizer];
    nextFluidViewExample.alpha = 0.0;
    [self.view insertSubview:nextFluidViewExample aboveSubview:self.swipeForNextExampleLabel];
    
    [UIView animateWithDuration:0.5 animations:^{
        nextFluidViewExample.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.exampleContainerView removeFromSuperview];
        self.exampleContainerView = nextFluidViewExample;
    }];
}
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    [self applyNextAnimation];
}

- (void)applyNextAnimation {
    // Finish when there are no more animations to run
    if ([[self sequenceOfAnimations] count] == 0) {
        //        [self addGestureRecognizer:self.tapGestureRecognizer];
        return;
    }
    
    // Get the next animation and remove it from the "queue"
    CABasicAnimation * nextAnimation = [[self sequenceOfAnimations] objectAtIndex:0];
    [[self sequenceOfAnimations] removeObjectAtIndex:0];
    
    // Get the layer and apply the animation
    CALayer *layerToAnimate = [nextAnimation valueForKey:@"layerToApplyAnimationTo"];
    [layerToAnimate addAnimation:nextAnimation forKey:nil];
}
- (void) moveXLayer:(CALayer *)layer time:(float)time X:(NSNumber *)x
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:@"moveX"];
}
- (void) runSpinAnimationOnView:(CALayer *)layer duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat
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
    CGFloat angleToAdd   = M_PI; // 90 deg = pi/2
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
- (BAFluidView*) nextBAFluidViewExample
{
    switch (self.currentWaterLevel)
    {
        case 0:
        {
            NSLog(@"Case 0 is happening.");
            
            self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:@0.25];
            self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
            [self.fluidView keepStationary];
            
            // Initialize first fish images
            self.fishView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 162.9, 120.6)];
            self.fishImage = [UIImage imageNamed:@"Wilfred-Meh"];
            self.fishImageView = [[UIImageView alloc] initWithImage:self.fishImage];
            self.fishImageView.contentMode = UIViewContentModeScaleAspectFit; // Change size
            self.fishImageView.frame = self.fishView.bounds;
            [self.fishView addSubview:self.fishImageView];
            [self.view addSubview:self.fishView];
            
            CGRect viewBounds = [[self view] frame];
            [self.fishImageView.layer setPosition:CGPointMake(viewBounds.size.width / 2.0, viewBounds.size.height / 1.20 - viewBounds.origin.y)];
            [self.fishImageView.layer bts_startWiggling];
            
            [self swimFishWithDuration:8];
            
            return self.fluidView;
        }
        case 1:
        {
            NSLog(@"Case 1 is happening.");
            [self waterLevelAnimationStart:@0.250 fillTo:@0.325];

            return self.fluidView;
        }
        case 2:
        {
            NSLog(@"Case 2 is happening.");
            [self waterLevelAnimationStart:@0.325 fillTo:@0.400];

            
            return self.fluidView;
        }
        case 3:
        {
            NSLog(@"Case 3 is happening.");
            [self waterLevelAnimationStart:@0.400 fillTo:@0.475];
         
            return self.fluidView;
        }
        case 4:
        {
            NSLog(@"Case 4 is happening.");
            [self waterLevelAnimationStart:@0.475 fillTo:@.550];

            return self.fluidView;
        }
        case 5:
        {
            NSLog(@"Case 5 is happening.");
            [self waterLevelAnimationStart:@0.550 fillTo:@.625];

            return self.fluidView;
        }
        case 6:
        {
            NSLog(@"Case 6 is happening.");
            [self waterLevelAnimationStart:@0.625 fillTo:@.700];
         
            return self.fluidView;
        }
        case 7:
        {
            NSLog(@"Case 7 is happening.");
            [self waterLevelAnimationStart:@0.700 fillTo:@.775];

            return self.fluidView;
        }
        case 8:
        {
            NSLog(@"Case 8 is happening.");
            [self waterLevelAnimationStart:@0.775 fillTo:@.850];

            return self.fluidView;
        }
        case 9:
        {
            NSLog(@"Case 9 is happening.");
            [self waterLevelAnimationStart:@0.850 fillTo:@.925];
            
            return self.fluidView;
        }
        default:
        {
            NSLog(@"DEFAULT is happening.");

            self.currentWaterLevel = 0;
            return [self nextBAFluidViewExample];
        }
    }
    return nil;
}
- (void) waterLevelAnimationStart:(NSNumber *)startElevation fillTo:(NSNumber *)fillTo
{
    self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:startElevation];
    self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
    self.fluidView.fillDuration = 4.3;
    self.fluidView.fillRepeatCount = 0.5;
    [self.fluidView fillTo:fillTo];
    [self.fluidView startAnimation];
}
- (void) swimFishWithDuration:(NSUInteger)duration{
    CGPoint originalOrigin = self.fishImageView.frame.origin;
    CGSize originalSize = self.fishImageView.frame.size;
    
    [UIView animateKeyframesWithDuration:4
                                   delay:0
                                 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                              animations:^{
                                  
                                  // swim left
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:1/4.0
                                                                animations:^{
                                                                    self.fishImageView.frame = CGRectMake(0,
                                                                                                          originalOrigin.y,
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
                                                                                                          originalOrigin.y,
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
                                                                                                          originalOrigin.y,
                                                                                                          originalSize.width,
                                                                                                          originalSize.height);
                                                                }];
                                  
                              } completion:^(BOOL finished) {
                                  
                                  
                              }];

}
- (void) swimUpByHeight:(NSInteger)height {
    CGRect viewBounds = [[self view] frame];
    CGPoint originalOrigin = self.fishImageView.frame.origin;
    CGSize originalSize = self.fishImageView.frame.size;
    
    [self.fishImageView.layer removeAllAnimations];
    [UIView animateKeyframesWithDuration:2
                                   delay:0
                                 options:UIViewAnimationCurveLinear
                              animations:^{
                                  self.fishImageView.frame = CGRectMake(originalOrigin.x,
                                                                        originalOrigin.y - viewBounds.size.height/height,
                                                                        originalSize.width,
                                                                        originalSize.height);
                              }
                              completion:nil];
}

@end