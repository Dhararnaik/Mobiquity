//
//  testLoginViewController.m
//  MobiquityPhotoGallery
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import "testLoginViewController.h"
#import "testMasterViewController.h"

@interface testLoginViewController ()

@end

@implementation testLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.btnPhotos setEnabled:NO];
    
    if ([[DBSession sharedSession] isLinked])
    {
        [self.btnLogin setTitle:@"Unlink Drop Box" forState:UIControlStateNormal];
        [self performSegueWithIdentifier:@"showPhotoList" sender:self];
        [self.btnPhotos setEnabled:YES];

    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginToDropBox:(UIButton *)sender {
    
    if (![[DBSession sharedSession] isLinked]) {
        
        [[DBSession sharedSession] linkFromController:self];
        [self.btnLogin setTitle:@"Unlink Drop Box" forState:UIControlStateNormal];
        [self performSegueWithIdentifier:@"showPhotoList" sender:self];
        [self.btnPhotos setEnabled:YES];
    }
    else
    {
        [self.btnLogin setTitle:@"Link Drop Box" forState:UIControlStateNormal];
        [[DBSession sharedSession] unlinkAll];
        UIAlertView *unlinkAlert = [[UIAlertView alloc] initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unlinkAlert show];
        [self.btnPhotos setEnabled:NO];
    }
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showPhotoList"]) {
        
        testMasterViewController *myDestinationController = [[testMasterViewController alloc] init];
        myDestinationController = (testMasterViewController *) [segue destinationViewController];
        if(self.managedObjectContext) {
            myDestinationController.managedObjectContext = self.managedObjectContext;
        }
    }
  
}



- (IBAction)showPhotos:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"showPhotoList" sender:self];

}
@end
