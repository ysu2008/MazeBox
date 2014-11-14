//
//  ViewController.h
//  MazeBox
//
//  Created by Yang Su on 11/9/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MazeBoxViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *inputText;
@property (strong, nonatomic) IBOutlet UITextView *outputText;

- (IBAction)didTapComputeButton:(id)sender;


@end

