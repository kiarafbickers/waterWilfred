//
//  WWAUserData.m
//  WaterWilfred
//
//  Created by Kiara Robles on 10/28/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "WWAUserData.h"

@interface WWAUserData ()

@property (nonatomic, readwrite) NSUInteger currentWeight;

@end

@implementation WWAUserData

- (instancetype)initWithCurrentWeight:(NSUInteger)currentWeight
{
    self = [super init];
    if (self) {
        _currentWeight = [self calulateCurrentWeight];
        _glasses = [self calculateWaterIntake:currentWeight];
        _alertToDrinkWater = self.glasses;
    }
    return self;
}

- (NSUInteger)calculateWaterIntake:(NSUInteger)currentWeight {
    
    NSInteger numberOfOunces;
    NSInteger numberOfCups;
    
    numberOfOunces = currentWeight/2;
    numberOfCups = numberOfOunces/8;
    NSLog(@"You need to drink %lu cups of water per day", numberOfCups);
    
    return self.glasses = numberOfCups;
}

-(NSUInteger)calulateCurrentWeight {
    NSNumber *weightNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentWeight"];
    
    if(weightNumber) {
        return weightNumber.unsignedIntegerValue;
    }
    
    return 0;
}

-(void)setCurrentWeight:(NSUInteger)currentWeight {
    [[NSUserDefaults standardUserDefaults] setObject:@(currentWeight) forKey:@"currentWeight"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
