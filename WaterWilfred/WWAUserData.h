//
//  WWAUserData.h
//  WaterWilfred
//
//  Created by Kiara Robles on 10/28/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWAUserData : NSObject

@property (nonatomic, readonly) NSUInteger currentWeight;
@property (nonatomic) NSUInteger alertToDrinkWater;
@property (nonatomic) NSUInteger glasses;
@property (nonatomic) NSNumber *currentWaterLevel;
@property (nonatomic, strong) NSArray *glassesArrayTest;

- (instancetype)initWithCurrentWeight:(NSUInteger)currentWeight;
- (NSArray *)calculateWaterIntake:(NSUInteger)currentWeight;

// Overiding the setter and getter
- (NSUInteger)currentWeight;
- (void)setCurrentWeight:(NSUInteger)currentWeight;

@end
