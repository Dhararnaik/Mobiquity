//
//  testCustomPhotoListCell.h
//  MobiquityPhotoGallery
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testCustomPhotoListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblPhotoTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblLastModified;

@end
