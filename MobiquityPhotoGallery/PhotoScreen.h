//
//  PhotoScreen.h
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MapKit/MapKit.h>



@interface PhotoScreen : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, DBRestClientDelegate>
{
    IBOutlet UIImageView* photo;
    IBOutlet UIBarButtonItem* btnAction;
    IBOutlet UITextField* fldTitle;
    DBRestClient* restClient;
    ALAssetsLibrary *assetsLibrary;


}

//show the app menu 
-(IBAction)btnActionTapped:(id)sender;


@end
