//
//  WWACustomCell.m
//  WaterWilfred
//
//  Created by Selma NB on 11/4/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import "WWACustomCell.h"

@interface WWACustomCell () <BEMCheckBoxDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cupOfWaterImage;

@end


@implementation WWACustomCell


-(void)awakeFromNib
{
    self.checkBox.delegate = self;
}

-(void)didTapCheckBox:(BEMCheckBox *)checkBox
{
    self.waterCup.isChecked = checkBox.on;
    [self.delegate checkboxTappedInCustomCell:self];
    
}
-(void)setWaterCup:(WWAWaterCup *)waterCup
{
    _waterCup = waterCup;
    [self.checkBox setOn:waterCup.isChecked];
}

@end
