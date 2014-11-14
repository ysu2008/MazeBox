//
//  ViewController.m
//  MazeBox
//
//  Created by Yang Su on 11/9/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import "MazeBoxViewController.h"

#import "MazeBoxSolver.h"

@interface MazeBoxViewController ()

@end

@implementation MazeBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapComputeButton:(id)sender {
    NSString *input = self.inputText.text;
    MazeBoxSolver *solver = [[MazeBoxSolver alloc] initWithInputText:input];
    NSString *solution = [solver solve];
    self.outputText.text = solution;
}
@end
