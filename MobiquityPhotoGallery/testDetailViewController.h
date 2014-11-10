//
//  testDetailViewController.h
//  MobiquityPhotoGallery
//
//  Created by Kikani, Vibhu on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
