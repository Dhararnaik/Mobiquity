//
//  testNotesViewController.h
//  MobiquityPhotoGallery
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Note.h"

@class Note;

@interface testNotesViewController : UIViewController <UITextViewDelegate>



@property (strong, nonatomic) IBOutlet UIBarButtonItem *brbDone;
@property Note* note;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;


- (IBAction)doneClicked:(UIBarButtonItem *)sender;



@end
