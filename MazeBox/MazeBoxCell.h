//
//  MazeBoxCell.h
//  MazeBox
//
//  Created by Yang Su on 11/10/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MazeBoxCell : NSObject

@property (nonatomic, readonly, assign) int x;
@property (nonatomic, readonly, assign) int y;
@property (nonatomic, readonly, assign) int z;
@property (nonatomic, readonly, assign) BOOL isTransparent;

- (id)initWithX:(int)x Y:(int)y Z:(int)z
  isTransparent:(BOOL)isTransparent;

@end