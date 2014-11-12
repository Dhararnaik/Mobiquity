//
//  PhotoScreen.m
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import "PhotoScreen.h"
#import "UIImage+Resize.h"
#import "UIAlertView+error.h"
#import "testNotesViewController.h"


@interface PhotoScreen(private)

-(void)takePhoto;
-(void)effects;
-(void)uploadPhoto;
-(void)logout;
@property (nonatomic, readonly) DBRestClient* restClient;



@end

@implementation PhotoScreen
{
    NSMutableArray *photoArray;
    NSMutableDictionary *contentDictionary;
}

#pragma mark - View lifecycle
-(void)viewDidLoad {
    [super viewDidLoad];
    // Custom initialization
    self.navigationItem.rightBarButtonItem = btnAction;
    self.navigationItem.title = @"Post photo";
    
    restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    restClient.delegate = self;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - menu

-(IBAction)btnActionTapped:(id)sender {
	[fldTitle resignFirstResponder];
	//show the app menu
	[[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:@"Take photo", @"Effects!",@"Add Notes", @"Post Photo", nil]
	 showInView:self.view];

}

-(void)takePhoto {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
     
}

-(void)effects {
    //apply sepia filter - taken from the Beginning Core Image from iOS5 by Tutorials
    CIImage *beginImage = [CIImage imageWithData: UIImagePNGRepresentation(photo.image)];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    photo.image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
}



-(void)uploadPhoto {
    
    //upload the image and the title to the web service
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"upload.jpg"];
    NSData *data = UIImageJPEGRepresentation(photo.image,70);
    
    [data writeToFile:path atomically:YES];
    NSLog(@"File Name == %@",path);
    
    NSString *pathString;
    NSString *fileTitle;
    

    if ([DBSession sharedSession].root == kDBRootDropbox) {
        pathString = @"/Photos";
    } else {
        pathString = @"/";
    }
    
    
    if (fldTitle.text.length > 0) {
        fileTitle = [NSString stringWithFormat:@"%@.%@",fldTitle.text, @"jpg"];
    }
    else
    {
        fileTitle = [NSString stringWithFormat:@"%@.%@",@"Upload", @"jpg"];
    }
    
    NSLog(@" Text field Value == %@", fileTitle);

    [restClient uploadFile:fileTitle toPath:pathString withParentRev:nil fromPath:path];
}




- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
   
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
    
}

-(void)addNotes
{
    [self performSegueWithIdentifier:@"writeNote" sender:self];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhoto]; 
			break;
        case 1:
            [self effects];
			break;
        case 2:
            [self addNotes];
			break;

        case 3:
            [self uploadPhoto]; 
			break;

    }
}




#pragma mark - Image picker delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // Resize the image from the camera
	UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(photo.frame.size.width, photo.frame.size.height) interpolationQuality:kCGInterpolationHigh];
    // Crop the image to a square (yikes, fancy!)
    UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width -photo.frame.size.width)/2, (scaledImage.size.height -photo.frame.size.height)/2, photo.frame.size.width, photo.frame.size.height)];
    // Show the photo on the screen
    photo.image = croppedImage;
   
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    photoArray = [[NSMutableArray alloc] init];
    contentDictionary = [[NSMutableDictionary alloc] init];
    
    NSURL *imageUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSString *stringUrl = imageUrl.absoluteString;
    NSURL *asssetURL = [NSURL URLWithString:stringUrl];
    
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSLog(@"%@ ", asssetURL);

    [library assetForURL:asssetURL resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        NSDictionary *metadata = rep.metadata;
        NSLog(@"%@ ", metadata);
        
        CGImageRef iref = [rep fullScreenImage] ;
        
        if (iref) {
            photo.image = [UIImage imageWithCGImage:iref];
        }
    } failureBlock:^(NSError *error) {
        // error handling
    }];
    

    [picker dismissViewControllerAnimated:YES completion:nil];
}
     

//**************************************************************************************
-(NSMutableArray *) getContentFrom:(ALAssetsGroup *) group withAssetFilter:(ALAssetsFilter *)filter
{
    NSMutableArray *contentArray = [NSMutableArray array];
    [group setAssetsFilter:filter];
    
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        //ALAssetRepresentation holds all the information about the asset being accessed.
        if(result)
        {
            
            ALAssetRepresentation *representation = [result defaultRepresentation];
            
            //Stores releavant information required from the library
            NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
            //Get the url and timestamp of the images in the ASSET LIBRARY.
            NSString *imageUrl = [representation UTI];
            NSDictionary *metaDataDictonary = [representation metadata];
            NSString *dateString = [result valueForProperty:ALAssetPropertyDate];
            
            //            NSLog(@"imageUrl %@",imageUrl);
            //            NSLog(@"metadictionary: %@",metaDataDictonary);
            
            //Check for the date that is applied to the image
            // In case its earlier than the last sync date then skip it. ##TODO##
            
            NSString *imageKey = @"ImageUrl";
            NSString *metaKey = @"MetaData";
            NSString *dateKey = @"CreatedDate";
            
            [tempDictionary setObject:imageUrl forKey:imageKey];
            [tempDictionary setObject:metaDataDictonary forKey:metaKey];
            [tempDictionary setObject:dateString forKey:dateKey];
            
            //Add the values to photos array.
            [contentArray addObject:tempDictionary];
        }
    }];
    return contentArray;
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];

}
     

//**************************************************************************************
- (DBRestClient*)restClient {
 if (restClient == nil) {
     restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
     restClient.delegate = self;
 }
 return restClient;
}


     
     
@end
