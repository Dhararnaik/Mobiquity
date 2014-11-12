//
//  Note.h
//  MobiquityPhotoGallery
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property NSString* contents;
@property NSDate* timestamp;

// an automatically generated not title, based on the first few words
@property (readonly) NSString* title;

+ (Note*) noteWithText:(NSString*)text;

@end
