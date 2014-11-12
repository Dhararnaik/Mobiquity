//
//  testAppDelegate.h
//  MobiquityPhotoGallery
//
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//*********************************************************

#import <UIKit/UIKit.h>
#import "testLoginViewController.h"


@interface testAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *relinkUserId;
    testLoginViewController *controller;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
