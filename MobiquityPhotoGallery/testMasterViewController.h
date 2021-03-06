//
//  testMasterViewController.h
//  MobiquityPhotoGallery
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@class DBRestClient;


@interface testMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate,DBRestClientDelegate,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *brbPhotos;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)showPhotos:(UIBarButtonItem *)sender;

@end
