//
//  testMasterViewController.h
//  MobiquityPhotoGallery
//
//  Created by Kikani, Vibhu on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface testMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
