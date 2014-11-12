//
//  testNotesViewController.m
//  MobiquityPhotoGallery
//
//  Created by Naik, Dhara on 11/10/14.
//  Copyright (c) 2014 Mobiquity. All rights reserved.
//

#import "testNotesViewController.h"
#import "testHighlightTextStorage.h"

@interface testNotesViewController ()
{
    testHighlightTextStorage* _textStorage;
    UITextView* _textView;
}
@end

@implementation testNotesViewController

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
    
    UIColor* navColor = [UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:1.0f];
    [[UINavigationBar appearance] setBarTintColor:navColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(preferredContentSizeChanged:)
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];
    
    _note.contents = @"This is new Note !!";
    
    [self createTextView];


}



- (void)createTextView
{
    // 1. Create the text storage that backs the editor
    NSDictionary* attrs = @{NSFontAttributeName:
                                [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSAttributedString* attrString = [[NSAttributedString alloc]
                                      initWithString:@"This is new Note !!"
                                      attributes:attrs];
    _textStorage = [testHighlightTextStorage new];
    [_textStorage appendAttributedString:attrString];
    
    CGRect newTextViewRect = self.view.bounds;
    
    // 2. Create the layout manager
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    // 3. Create a text container
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width,  newTextViewRect.size.height);
    
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [_textStorage addLayoutManager:layoutManager];
    
    // 4. Create a UITextView
    _textView = [[UITextView alloc] initWithFrame:newTextViewRect
                                    textContainer:container];
    _textView.delegate = self;
    [self.backgroundView addSubview:_textView];
}


-(void)viewDidLayoutSubviews
{
    _textView.frame = self.view.bounds;
}

//**************************************************************************************
- (void)preferredContentSizeChanged:(NSNotification *)notification {
  //  self.noteTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

}

//**************************************************************************************
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//**************************************************************************************
- (IBAction)doneClicked:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
