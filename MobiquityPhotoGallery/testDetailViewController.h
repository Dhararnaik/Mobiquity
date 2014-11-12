//
//  testDetailViewController.h
//  MobiquityPhotoGallery
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property(strong, nonatomic) NSString *imageName;
@property(strong, nonatomic) UIImage *imgFullImage;


@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgDetailImage;

@end
