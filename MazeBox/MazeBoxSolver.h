//
//  MazeBoxSolver.h
//  MazeBox
//
//  Created by Yang Su on 11/9/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MazeBoxSolver : NSObject

- (id)initWithInputText:(NSString *)inputText;
- (NSString *)solve;

@end
