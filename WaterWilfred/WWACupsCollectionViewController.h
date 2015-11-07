//
//  WWACupsCollectionViewController.h
//  WaterWilfred
//
//  Created by Selma NB on 11/2/15.
//  Copyright © 2015 Kiara Robles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWAViewController.h"
#import "BEMCheckBox.h"
#import "WWAViewController.h"
#import "WWAUserData.h"

@interface WWACupsCollectionViewController : UICollectionViewController

@property (strong, nonatomic) WWAUserData *userData;
@property (nonatomic) NSInteger checkedCups;

@end
