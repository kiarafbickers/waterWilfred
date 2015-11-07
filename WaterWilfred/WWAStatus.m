//
//  WWAStatus.m
//  WaterWilfred
//
//  Created by Selma NB on 11/4/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "WWAStatus.h"
#import <BAFluidView/BAFluidView.h>
#import "WWACupsCollectionViewController.h"


@interface WWAStatus ()


@property (weak, nonatomic) IBOutlet BAFluidView *fluidView;



@end


@implementation WWAStatus

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSLog(@"What are you: %f", self.percentageOfCups);
 
    [self.fluidView fillTo:@(self.percentageOfCups)];
    self.fluidView.fillRepeatCount =1;

    
    }

@end
