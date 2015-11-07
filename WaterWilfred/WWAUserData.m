//
//  WWAUserData.m
//  WaterWilfred
//
//  Created by Kiara Robles on 10/28/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "WWAUserData.h"
#import "WWAWaterCup.h"

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

-(NSArray *)calculateWaterIntake:(NSUInteger)currentWeight{
    
    NSInteger numberOfOunces;
    numberOfOunces = currentWeight/2;
    NSMutableArray *numberOfCups =[NSMutableArray new];
    
    for (NSUInteger i = 0; i < numberOfOunces/8; i++)
    {
        WWAWaterCup *newCup = [[WWAWaterCup alloc] init];
        newCup.isChecked = NO;
        [numberOfCups addObject:newCup];
    }
    return self.glassesArrayTest = numberOfCups;
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
