//
//  testHighlightTextStorage.m
//  MobiquityPhotoGallery
//
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import "testHighlightTextStorage.h"

@implementation testHighlightTextStorage
{
    NSMutableAttributedString *_backingStore;
}


-(void)update {
    // update the highlight patterns
   // [self createHighlightPatterns];
    
    // change the 'global' font
    NSDictionary* bodyFont = @{NSFontAttributeName :
                                   [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    [self addAttributes:bodyFont
                  range:NSMakeRange(0, self.length)];
    
    // re-apply the regex matches
    [self applyStylesToRange:NSMakeRange(0, self.length)];
}


- (NSDictionary*)createAttributesForFontStyle:(NSString*)style
                                    withTrait:(uint32_t)trait {
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor
                                        preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    
    UIFontDescriptor *descriptorWithTrait = [fontDescriptor
                                             fontDescriptorWithSymbolicTraits:trait];
    
    UIFont* font =  [UIFont fontWithDescriptor:descriptorWithTrait size: 0.0];
    return @{ NSFontAttributeName : font };
}





-(void)processEditing
{
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}


- (void)performReplacementsForRange:(NSRange)changedRange
{
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string]
                                                        lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_backingStore string]
                                                lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    [self applyStylesToRange:extendedRange];
}


- (void)applyStylesToRange:(NSRange)searchRange
{
    // 1. create some fonts
    UIFontDescriptor* fontDescriptor = [UIFontDescriptor
                                        preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor* boldFontDescriptor = [fontDescriptor
                                            fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont* boldFont =  [UIFont fontWithDescriptor:boldFontDescriptor size: 0.0];
    UIFont* normalFont =  [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    // 2. match items surrounded by asterisks
    NSString* regexStr = @"(\\*\\w+(\\s\\w+)*\\*)\\s";
    NSRegularExpression* regex = [NSRegularExpression
                                  regularExpressionWithPattern:regexStr
                                  options:0
                                  error:nil];
    
    NSDictionary* boldAttributes = @{ NSFontAttributeName : boldFont };
    NSDictionary* normalAttributes = @{ NSFontAttributeName : normalFont };
    
    // 3. iterate over each match, making the text bold
    [regex enumerateMatchesInString:[_backingStore string]
                            options:0
                              range:searchRange
                         usingBlock:^(NSTextCheckingResult *match,
                                      NSMatchingFlags flags,
                                      BOOL *stop){
                             
                             NSRange matchRange = [match rangeAtIndex:1];
                             [self addAttributes:boldAttributes range:matchRange];
                             
                             // 4. reset the style to the original
                             if (NSMaxRange(matchRange)+1 < self.length) {
                                 [self addAttributes:normalAttributes
                                               range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
                             }
                         }];
}




- (id)init
{
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
    }
    return self;
}


- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location
                             effectiveRange:range];
}


- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    NSLog(@"replaceCharactersInRange:%@ withString:%@", NSStringFromRange(range), str);
    
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self  edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes
            range:range
   changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    NSLog(@"setAttributes:%@ range:%@", attrs, NSStringFromRange(range));
    
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}


@end
