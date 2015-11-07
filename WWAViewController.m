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
#import <ACPReminder/ACPReminder.h>

@interface WWAViewController ()

@property (strong,nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) UIView *swipeLabel;
@property (strong,nonatomic) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (strong,nonatomic) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (strong,nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (strong,nonatomic) CABasicAnimation *fadeIn;
@property (strong,nonatomic) CABasicAnimation *fadeOut;
@property (strong,nonatomic) NSMutableArray *examplesArray;
@property (assign,nonatomic) int currentExample;
@property (assign,nonatomic) BOOL activity;
@property (assign,nonatomic) NSTimer *timer;
@property (assign,nonatomic) BOOL firstTimeLoading;
@property(assign,nonatomic) CAGradientLayer *gradient;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@end

@implementation WWAViewController


#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpBackground];
    
    self.activity = NO;
    self.firstTimeLoading = YES;
    
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];

    
    self.currentExample = 0;
    
    //For fading in swipe labels and timing it's appearance
    self.fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    self.fadeIn.duration = 2.0;
    self.fadeIn.fromValue = @0.0f;
    self.fadeIn.toValue = @1.0f;
    self.fadeIn.removedOnCompletion = NO;
    self.fadeIn.fillMode = kCAFillModeForwards;
    self.fadeIn.additive = NO;
    
    self.fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    self.fadeOut.duration = 0.5f;
    self.fadeOut.fromValue = @1.0f;
    self.fadeOut.toValue = @0.0f;
    self.fadeOut.removedOnCompletion = NO;
    self.fadeOut.fillMode = kCAFillModeForwards;
    self.fadeOut.additive = NO;
}

- (void)viewDidLayoutSubviews {
    
    if (self.firstTimeLoading) {
        self.firstTimeLoading = NO;
        self.exampleContainerView = [self nextBAFluidViewExample];
        [self.view insertSubview:self.exampleContainerView belowSubview:self.swipeForNextExampleLabel];
        [self.exampleContainerView addGestureRecognizer:self.leftSwipeGestureRecognizer];
        [self.exampleContainerView addGestureRecognizer:self.rightSwipeGestureRecognizer];
    }
}

- (void)setUpBackground {
    //sets up the green background [for fun - even though there an image :) ]
    if (self.gradient) {
        [self.gradient removeFromSuperlayer];
        self.gradient = nil;
    }
    
    //resetting a gradient layer causes the iphone6 simulator to fail (weird bug)
    CAGradientLayer *tempLayer = [CAGradientLayer layer];
    tempLayer.frame = self.view.bounds;
    tempLayer.colors = @[(id)[UIColor colorWithHex:0x53cf84].CGColor,(id)[UIColor colorWithHex:0x53cf84].CGColor, (id)[UIColor colorWithHex:0x2aa581].CGColor, (id)[UIColor colorWithHex:0x1b9680].CGColor];
    tempLayer.locations = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:0.5f],[NSNumber numberWithFloat:0.8f], [NSNumber numberWithFloat:1.0f]];
    tempLayer.startPoint = CGPointMake(0, 0);
    tempLayer.endPoint = CGPointMake(1, 1);
    
    self.gradient = tempLayer;
    [self.backgroundView.layer insertSublayer:self.gradient atIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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


#pragma mark - Private

- (void)showSwipeForNextExampleLabel {
    //call to action in case user doesn't swipe
    if (!self.activity) {
        [self.swipeForNextExampleLabel.layer removeAllAnimations];
        self.swipeForNextExampleLabel.layer.opacity = 1;
        [self.swipeForNextExampleLabel.layer addAnimation:self.fadeIn forKey:@"fadeIn"];
    }
    
}

- (void)hideSwipeForNextExampleLabel {
    [self.swipeForNextExampleLabel.layer removeAllAnimations];
    self.swipeForNextExampleLabel.layer.opacity = 0;
    [self.swipeForNextExampleLabel.layer addAnimation:self.fadeOut forKey:@"fadeOut"];
}


-(void)transitionToNextExample{
    
    //This adds the dragging and falling functionality
    if(self.swipeForNextExampleLabel.alpha > 0){
        [self hideSwipeForNextExampleLabel];
    }
    
    self.activity = NO;
    [self.animator removeAllBehaviors];
    
    self.currentExample++;
    
    //show new example
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
    NSString *zRotationKeyPath = @"transform.rotation.z"; // The killer of typos
    
    CGFloat currentAngle = [[layer valueForKeyPath:zRotationKeyPath] floatValue];
    CGFloat angleToAdd   = M_PI; // 90 deg = pi/2
    [layer setValue:@(currentAngle+angleToAdd) forKeyPath:zRotationKeyPath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:zRotationKeyPath];
    animation.duration = duration;
    animation.toValue = @(0.0);        // model value was already changed. End at that value
    animation.byValue = @(angleToAdd); // start from - this value (it's toValue - byValue (see above))
    animation.repeatCount = repeat;
    
    // Add the animation. Once it completed it will be removed and you will see the value
    // of the model layer which happens to be the same value as the animation stopped at.
    [layer addAnimation:animation forKey:@"90rotation"];
    
}

- (void)runBigSpinAnimationOnView:(CALayer*)layer duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
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
-(BAFluidView*) nextBAFluidViewExample {
    
    switch (self.currentExample) {
        case 0:
        {
            // Fill view with water
            self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:@0.55];
            self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
            [self.fluidView keepStationary];
            
            self.message = [UILabel new];
            
            // Set Label text
            [self.view addSubview:self.message];
            self.message.backgroundColor = [UIColor clearColor];
            self.message.text = @"Congrats on your new pet!\nMeet Wilfred.";
            self.message.font = [UIFont fontWithName:@"Helvetica" size:20];
            self.message.numberOfLines = 2;
            self.message.textAlignment = NSTextAlignmentCenter;
            

            // Creating constraints using Layout Anchors
            self.message.translatesAutoresizingMaskIntoConstraints = NO;
            [self.message.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
            [self.message.centerYAnchor constraintEqualToAnchor:self.view.topAnchor constant:100].active = YES;
            [self.message.widthAnchor constraintEqualToConstant:300.0f].active = YES;
            [self.message.heightAnchor constraintEqualToConstant:150.0f].active = YES;
            
            // Add fish image
            self.fishLayer = [CALayer layer];
            [self.fishLayer setContents:(__bridge id)[[UIImage imageNamed:@"Wilfred-Happy.png"] CGImage]];
            [self.fishLayer setContentsScale:[[UIScreen mainScreen] scale]];
            [self.fishLayer setBounds:CGRectMake(0.0, 0.0, 162.9, 120.6)];
            [[[self view] layer] addSublayer:self.fishLayer];
            
            CGRect viewBounds = [[self view] frame];
            [self.fishLayer setPosition:CGPointMake(viewBounds.size.width / 2.0, viewBounds.size.height / 1.5 - viewBounds.origin.y)];
        
            CALayer *wiggleLayer = [self wiggleLayer];
            [wiggleLayer bts_startWiggling];
            
            
            return self.fluidView;
        }
            
        case 1:
        {
            // Move water
            self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:@0.55];
            self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
            self.fluidView.fillDuration = 5.0;
            self.fluidView.fillRepeatCount = 0.5;
            [self.fluidView fillTo:@0.25];
            [self.fluidView startAnimation];
            
            // Move fish
            CGRect viewBounds = [[self view] frame];
            [self.fishLayer setPosition:CGPointMake(viewBounds.size.width / 2.0, viewBounds.size.height / 1.20 - viewBounds.origin.y)];
            
            // UILabel *label1 = [UILabel new];
            
            [self.view addSubview:self.message];
            self.message.text = @"Every morning his water\nstarts out low...";
            self.message.font = [UIFont fontWithName:@"Helvetica" size:20];
            
            return self.fluidView;
        }
            
        case 2:
        {
            // Move water
            self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:@0.25];
            self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
            self.fluidView.fillDuration = 5.0;
            self.fluidView.fillRepeatCount = 0.5;
            [self.fluidView fillTo:@0.72];
            [self.fluidView startAnimation];
            
            // Move fish
            CGRect viewBounds = [[self view] frame];
            [self.fishLayer setPosition:CGPointMake(viewBounds.size.width / 2.0, viewBounds.size.height / 1.25 - viewBounds.origin.y)];
            
            // Change message
            [self.view addSubview:self.message];
            self.message.text = @"As you drink,\nhis water level rises.";
            self.message.font = [UIFont fontWithName:@"Helvetica" size:20];
            
            return self.fluidView;
        }
            
        case 3:
        {
            // Move water
            self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:@0.72];
            self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
            [self.fluidView keepStationary];
            
            // Move fish
            CGRect viewBounds = [[self view] frame];
            [self.fishLayer setPosition:CGPointMake(viewBounds.size.width / 2.0, viewBounds.size.height / 1.25 - viewBounds.origin.y)];
            
            // Change message
            [self.view addSubview:self.message];
            self.message.text = @"Give your fish\nmore room to swim!";
            self.message.font = [UIFont fontWithName:@"Helvetica" size:20];
            
            //[self.fishLargerLayer addSublayer:self.fishLayer];
            
            [self runSpinAnimationOnView:self.fishLayer duration:1 rotations:1 repeat:1];
            //[self runBigSpinAnimationOnView:self.fishLayer duration:1 rotations:1 repeat:1];
            
            
            return self.fluidView;
        }
            
        case 4:
        {
            // Move water
            self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:@0.25];
            self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
            [self.fluidView keepStationary];
            
            // Move fish
            CGRect viewBounds = [[self view] frame];
            [self.fishLayer setPosition:CGPointMake(viewBounds.size.width / 2.0, viewBounds.size.height / 1.20 - viewBounds.origin.y)];
            
            // Change message
            [self.view addSubview:self.message];
            self.message.text = @"But forget to drink water\nand you might end up with\na dead fish.";
            self.message.numberOfLines = 3;
            
            [self runHalfSpinAnimationOnView:self.fishLayer duration:3 repeat:1];
            
            [self.fishLayer setContents:(__bridge id)[[UIImage imageNamed:@"Wilfred-DeadFloat.png"] CGImage]];
            // [self runBigSpinAnimationOnView:self.fishLayer duration:1 rotations:1 repeat:1];
            
            
            return self.fluidView;
        }
        
        case 5:
        {
            // Move water
            self.fluidView = [[BAFluidView alloc] initWithFrame:self.view.frame startElevation:@0.25];
            self.fluidView.fillColor = [UIColor colorWithHex:0x397ebe];
            [self.fluidView keepStationary];
            
            // Move fish
            CGRect viewBounds = [[self view] frame];
            [self.fishLayer setPosition:CGPointMake(viewBounds.size.width / 2.0, viewBounds.size.height / 1.20 - viewBounds.origin.y)];
            
            // Change message
            [self.view addSubview:self.message];
            self.message.text = @"Wilfed's, just playing!!";
            self.message.numberOfLines = 2;
            
            [self.fishLayer setContents:(__bridge id)[[UIImage imageNamed:@"Wilfred-Happy.png"] CGImage]];
            [self runHalfSpinAnimationOnView:self.fishLayer duration:3 repeat:1];
            
            return self.fluidView;

        }
        
        case 6:
        {
            WWAMainViewController *mainGame = [[WWAMainViewController alloc] init];
            [self presentViewController:mainGame animated:YES completion:nil];
            return nil;
            
        }
            
        default:
        {
            self.currentExample = 0;
            return [self nextBAFluidViewExample];
        }
    }
    
    return nil;
}
@end