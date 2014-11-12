//
//  Note.m
//  MobiquityPhotoGallery
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import "Note.h"

@implementation Note

+ (Note *)noteWithText:(NSString *)text {
    Note* note = [Note new];
    note.contents = text;
    note.timestamp = [NSDate date];
    return note;
}

- (NSString *)title {
    // split into lines
    NSArray* lines = [self.contents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    // return the first
    return lines[0];
}

@end
