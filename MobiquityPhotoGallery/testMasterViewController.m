//
//  testMasterViewController.m
//  MobiquityPhotoGallery
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import "testMasterViewController.h"
#import "testDetailViewController.h"
#import "testCustomPhotoListCell.h"
//#import "StreamScreen.h"

@interface testMasterViewController ()
{
    NSArray* photoPaths;
    NSString* photosHash;
    NSString* currentPhotoPath;
    BOOL working;
    DBRestClient* restClient;
    NSString *globalPath;
    NSMutableArray *fileName;
    NSMutableArray *lastModified;
    NSMutableArray *imagePaths;
}

@property (nonatomic, readonly) DBRestClient* restClient;

- (void)configureCell:(testCustomPhotoListCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSString*)photoPath;
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end


@implementation testMasterViewController


//**************************************************************************************
- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath {
    
    NSLog(@"Destination Path == %@", destPath);
    globalPath = destPath;
}



//**************************************************************************************
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata {
    photosHash = metadata.hash;
    
    NSArray* validExtensions = [NSArray arrayWithObjects:@"jpg", @"jpeg", nil];
    NSMutableArray* newPhotoPaths = [NSMutableArray new];
    fileName = [[NSMutableArray alloc] init];
    lastModified = [[NSMutableArray alloc] init];
    
    for (DBMetadata* child in metadata.contents) {
       
        NSString* extension = [[child.path pathExtension] lowercaseString];
        NSLog(@"Meta Data == %@",child.contents);
        
        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound) {
            [newPhotoPaths addObject:child.path];
            [fileName addObject:child.filename];
            [lastModified addObject:child.lastModifiedDate];
        }
    }
    photoPaths = newPhotoPaths;
    NSLog(@"Total Number of Images == %lu", (unsigned long)photoPaths.count);

    //[self loadRandomPhoto];
    [self.tableView reloadData];
    
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
    //[self loadRandomPhoto];
    
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
}



//**************************************************************************************
- (NSString*)photoPath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"photo.jpg"];
}



//**************************************************************************************
- (void)didPressRandomPhoto {
    NSString *photosRoot = nil;
    if ([DBSession sharedSession].root == kDBRootDropbox) {
        photosRoot = @"/Photos";
    } else {
        photosRoot = @"/";
    }
    [self.restClient loadMetadata:photosRoot withHash:photosHash];
}



//**************************************************************************************
- (void)awakeFromNib
{
    [super awakeFromNib];
}

//**************************************************************************************
- (void)viewDidLoad
{
    
    imagePaths = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    [self didPressRandomPhoto];
    [self.tableView reloadData];
    
    
}


//**************************************************************************************
-(void)viewWillAppear:(BOOL)animated
{
    [self didPressRandomPhoto];
    [self.tableView reloadData];
}


//**************************************************************************************
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View

//**************************************************************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

//**************************************************************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Photo Path Count == %ld", photoPaths.count);
    return photoPaths.count;
}


//**************************************************************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    testCustomPhotoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoListCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


//**************************************************************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
      
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        testDetailViewController *destination = (testDetailViewController *) segue.destinationViewController;
        NSData *imgData = [[NSData alloc] initWithContentsOfFile:[imagePaths objectAtIndex:indexPath.row]];
        destination.imgFullImage = [[UIImage alloc] initWithData:imgData];
        
    }
//    
//    if ([[segue identifier] isEqualToString:@"showPhotos"]) {
//        
//        //StreamScreen *destination =[segue destinationViewController];
//        destination.photoPaths = photoPaths;
//    }
}



//**************************************************************************************
-(UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//**************************************************************************************
- (void)configureCell:(testCustomPhotoListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    currentPhotoPath = [photoPaths objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString* path2 = [documentsDirectory stringByAppendingString:
                [NSString stringWithFormat:@"%@", currentPhotoPath]];
    
    
    [self.restClient loadThumbnail:currentPhotoPath ofSize:@"iphone_bestfit" intoPath:path2];
  //  [self.restClient loadFile:currentPhotoPath intoPath:path2];
    
    [imagePaths addObject:path2];
    NSData *imgData = [[NSData alloc] initWithContentsOfFile:path2];
    cell.imageView.image =  [self imageWithImage:[[UIImage alloc] initWithData:imgData] scaledToSize:CGSizeMake(60,60)];
    cell.lblPhotoTitle.text = [fileName objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMM,YYYY"];
    cell.lblLastModified.text = [dateFormatter stringFromDate:[lastModified objectAtIndex:indexPath.row]];
 }





//**************************************************************************************
- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

//**************************************************************************************
- (IBAction)showPhotos:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"showPhotos" sender:self];
    
}



@end
