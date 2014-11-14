//
//  MazeBoxCell.m
//  MazeBox
//
//  Created by Yang Su on 11/10/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import "MazeBoxCell.h"

@interface MazeBoxCell()

@property (nonatomic, readwrite, assign) int x;
@property (nonatomic, readwrite, assign) int y;
@property (nonatomic, readwrite, assign) int z;
@property (nonatomic, readwrite, assign) BOOL isTransparent;

@end

@implementation MazeBoxCell

- (id)initWithX:(int)x Y:(int)y Z:(int)z
  isTransparent:(BOOL)isTransparent {
    if (self = [super init]){
        _x = x;
        _y = y;
        _z = z;
        _isTransparent = isTransparent;
    }
    return self;
}

@end
