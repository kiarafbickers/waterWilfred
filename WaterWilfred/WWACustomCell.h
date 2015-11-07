//
//  WWACustomCell.h
//  WaterWilfred
//
//  Created by Selma NB on 11/4/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMCheckBox.h>
#import "WWAWaterCup.h"

@class WWACustomCell;
@protocol WWACustomCellDelegate <NSObject>

-(void)checkboxTappedInCustomCell:(WWACustomCell *)cell;

@end

@interface WWACustomCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet BEMCheckBox *checkBox;
@property (strong, nonatomic) WWAWaterCup *waterCup;
@property (nonatomic, weak) id<WWACustomCellDelegate> delegate;

@end
