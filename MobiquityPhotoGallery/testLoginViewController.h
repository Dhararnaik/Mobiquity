//
//  testLoginViewController.h
//  MobiquityPhotoGallery
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testLoginViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) IBOutlet UIButton *btnLogin;

- (IBAction)loginToDropBox:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnPhotos;
- (IBAction)showPhotos:(UIBarButtonItem *)sender;

@end
