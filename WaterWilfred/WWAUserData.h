//
//  WWAUserData.h
//  WaterWilfred
//
//  Created by Kiara Robles on 10/28/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWAUserData : NSObject

@property (nonatomic) NSUInteger currentWeight;
@property (nonatomic) NSUInteger numberOfTimesAlertedToDrinkWater;
@property (nonatomic) NSUInteger glasses;

- (NSUInteger)calculateWaterIntake:(NSUInteger)currentWeight;
- (void)userWeightInfo:(NSInteger)currentWeight;


@end
