//
//  WWACupsCollectionViewController.m
//  WaterWilfred
//
//  Created by Selma NB on 11/2/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "WWACupsCollectionViewController.h"
#import "WWAWaterCup.h"
#import "WWACustomCell.h"
#import "WWAStatus.h"

@interface WWACupsCollectionViewController() <WWACustomCellDelegate>

@end


@implementation WWACupsCollectionViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Select Cups";
    
}

#pragma mark - Collection View Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.userData.glassesArrayTest.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WWACustomCell *cell = (WWACustomCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellsIdentifier" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    // pull out the appropraite water cup
    WWAWaterCup *thisCup = self.userData.glassesArrayTest[indexPath.row];
    cell.waterCup = thisCup;
    return cell;
}

-(void)checkboxTappedInCustomCell:(WWACustomCell *)cell
{
    self.checkedCups = 0;
    for(WWAWaterCup *cup in self.userData.glassesArrayTest) {
        if(cup.isChecked) {
            self.checkedCups++;
        }
    }
    
    //NSLog some code to check status this could be removed once done
    NSLog(@"%lu cups are checked!", self.checkedCups);
    NSInteger countOfWaterIntake = self.userData.glassesArrayTest.count;
    if(self.checkedCups == countOfWaterIntake)
    {
        NSLog(@"Awesome JOB!");
    }else if(self.checkedCups == countOfWaterIntake/2 )
    {
        NSLog(@"You need to improve");
    }
    else if(self.checkedCups < countOfWaterIntake/2)
    {
        NSLog(@"You're dead");
    }
    
    [self performSegueWithIdentifier:@"cellSegue"
                              sender:nil];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selectedItemAtIndexPath: %@", indexPath);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSNumber *checkedCups = @(self.checkedCups);
    NSNumber *countOfTotalCups = @(self.userData.glassesArrayTest.count);
    
    CGFloat checkedCupsFloatValue = [checkedCups floatValue];
    CGFloat countOfTotalCupsFloatValue = [countOfTotalCups floatValue];
    
    CGFloat percentageOfCups = checkedCupsFloatValue/countOfTotalCupsFloatValue;
    
    WWAStatus *destinationVC = segue.destinationViewController;
    
    destinationVC.percentageOfCups = percentageOfCups;
}

@end
