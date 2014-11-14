//
//  MazeBoxSolver.m
//  MazeBox
//
//  Created by Yang Su on 11/9/14.
//  Copyright (c) 2014 Yang Su. All rights reserved.
//

#import "MazeBoxSolver.h"

#import "MazeBoxCell.h"

#define MAZE_BOX_SOLID_CUBE '#'
#define MAZE_BOX_TRANSPARENT_CUBE '.'
#define MAZE_BOX_BEGIN_CUBE 'B'
#define MAZE_BOX_END_CUBE 'E'

@interface MazeBoxSolver()

@property (nonatomic, readwrite, strong) NSMutableArray *maze; //index will be [z][y][x];
@property (nonatomic, readwrite, strong) NSMutableArray *prev;
@property (nonatomic, readwrite, strong) NSMutableArray *dist;
@property (nonatomic, readwrite, assign) int width;
@property (nonatomic, readwrite, assign) int height;
@property (nonatomic, readwrite, assign) int depth;
@property (nonatomic, readwrite, assign) int beginX; //width
@property (nonatomic, readwrite, assign) int beginY; //depth
@property (nonatomic, readwrite, assign) int beginZ; //height
@property (nonatomic, readwrite, assign) int endX;
@property (nonatomic, readwrite, assign) int endY;
@property (nonatomic, readwrite, assign) int endZ;

@end

@implementation MazeBoxSolver

- (id)initWithInputText:(NSString *)inputText {
    if (self = [super init]){
        NSMutableArray *maze = [NSMutableArray array];
        NSArray *inputArray = [inputText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        //useful info starts on row 3
        int rowIndex = 2;
        
        //input each row into the array
        NSMutableArray *level = [NSMutableArray array];
        for (;rowIndex < inputArray.count;rowIndex++){
            NSString *rowString = inputArray[rowIndex];
            if (rowString.length > 0){
                NSMutableArray *row = [NSMutableArray array];
                for (int i = 0; i < rowString.length; i++){
                    char currentChar = [rowString characterAtIndex:i];
                    [row addObject:[NSNumber numberWithChar:currentChar]];
                }
                [level addObject:row];
            }
            else {
                //new level
                [maze addObject:level];
                level = [NSMutableArray array];
            }
        }
        [maze addObject:level];
        
        //init height width and depth
        _height = (int)maze.count;
        _depth = (int)[(NSArray *)maze[0] count];
        _width = (int)[(NSArray *)maze[0][0] count];
        
        //create maze box cells for each cell
        for (int h = 0; h < _height; h++){
            for (int d = 0; d < _depth; d++){
                for (int w = 0; w < _width; w++){
                    char currentChar = [maze[h][d][w] charValue];
                    if (currentChar == MAZE_BOX_BEGIN_CUBE){
                        _beginX = w;
                        _beginY = d;
                        _beginZ = h;
                        maze[h][d][w] = [NSNumber numberWithChar:MAZE_BOX_TRANSPARENT_CUBE];
                        currentChar = MAZE_BOX_TRANSPARENT_CUBE;
                    }
                    else if (currentChar == MAZE_BOX_END_CUBE){
                        _endX = w;
                        _endY = d;
                        _endZ = h;
                        maze[h][d][w] = [NSNumber numberWithChar:MAZE_BOX_TRANSPARENT_CUBE];
                        currentChar = MAZE_BOX_TRANSPARENT_CUBE;
                    }
                    MazeBoxCell *cell = [[MazeBoxCell alloc] initWithX:w Y:d Z:h isTransparent:(currentChar == MAZE_BOX_TRANSPARENT_CUBE)];
                    maze[h][d][w] = cell;
                }
            }
        }
        
        _maze = maze;
        
        //initialize dist and prev array for dijkstra
        NSMutableArray *dist = [NSMutableArray array];
        NSMutableArray *prev = [NSMutableArray array];
        for (int h = 0; h < _height; h++){
            NSMutableArray *levelDist = [NSMutableArray array];
            NSMutableArray *levelPrev = [NSMutableArray array];
            for (int d = 0; d < _depth; d++){
                NSMutableArray *rowDist = [NSMutableArray array];
                NSMutableArray *rowPrev = [NSMutableArray array];
                for (int w = 0; w < _width; w++){
                    [rowDist addObject:[NSNumber numberWithInt:INT_MAX]];
                    [rowPrev addObject:[NSNull null]];
                }
                [levelDist addObject:rowDist];
                [levelPrev addObject:rowPrev];
            }
            [dist addObject:levelDist];
            [prev addObject:levelPrev];
        }
        _dist = dist;
        _prev = prev;
    }
    return self;
}

- (NSSet *)neighborsOfCell:(MazeBoxCell *)cell {
    NSMutableSet *set = [NSMutableSet set];
    if (cell.x > 0){
        [set addObject:self.maze[cell.z][cell.y][cell.x-1]];
    }
    if (cell.x < self.width - 1){
        [set addObject:self.maze[cell.z][cell.y][cell.x+1]];
    }
    if (cell.y > 0){
        [set addObject:self.maze[cell.z][cell.y-1][cell.x]];
    }
    if (cell.y < self.depth - 1){
        [set addObject:self.maze[cell.z][cell.y+1][cell.x]];
    }
    if (cell.z > 0){
        [set addObject:self.maze[cell.z-1][cell.y][cell.x]];
    }
    if (cell.z < self.height - 1){
        [set addObject:self.maze[cell.z+1][cell.y][cell.x]];
    }
    return set;
}

- (NSString *)solve {
    
    //Dijkstra's algorithm
    _dist[self.beginZ][self.beginY][self.beginX] = [NSNumber numberWithInt:0];
    
    NSMutableSet *unvisited = [NSMutableSet set];
    
    //put all nodes into unvisited
    for (int h = 0; h < _height; h++){
        for (int d = 0; d < _depth; d++){
            for (int w = 0; w < _width; w++){
                MazeBoxCell *cell = self.maze[h][d][w];
                [unvisited addObject:cell];
            }
        }
    }
    
    while (unvisited.count > 0){
        //I could use a min heap here to optimize but for now I'll just scan through the array
        int minDist = INT_MAX;
        MazeBoxCell *minCell = nil;
        for (MazeBoxCell *cell in unvisited){
            int currentDist = [self.dist[cell.z][cell.y][cell.x] intValue];
            if (currentDist <= minDist){
                minDist = currentDist;
                minCell = cell;
            }
        }
        [unvisited removeObject:minCell];
        
        //all unvisited neighbors of mincell
        for (MazeBoxCell *neighbor in [self neighborsOfCell:minCell]){
            if ([unvisited containsObject:neighbor]){
                if (neighbor.isTransparent){
                    int currentDistance = [self.dist[minCell.z][minCell.y][minCell.x] intValue] + 1;
                    if (currentDistance < [self.dist[neighbor.z][neighbor.y][neighbor.x] intValue]){
                        self.dist[neighbor.z][neighbor.y][neighbor.x] = [NSNumber numberWithInt:currentDistance];
                        self.prev[neighbor.z][neighbor.y][neighbor.x] = minCell;
                    }
                }
            }
        }
    }
    
    //shortest path is computed, so back it out
    if ([self.dist[self.endZ][self.endY][self.endX] intValue] == INT_MAX){
        return @"Not Escapable";
    }
    else {
        NSMutableArray *path = [NSMutableArray array];
        MazeBoxCell *lastCell = self.maze[self.endZ][self.endY][self.endX];
        while (lastCell && ![lastCell isEqual:[NSNull null]]){
            [path addObject:lastCell];
            lastCell = self.prev[lastCell.z][lastCell.y][lastCell.x];
        }
        return [self pathFromPathArray:path];
    }
}

- (NSString *)pathFromPathArray:(NSArray *)pathArray {
    NSMutableString *string = [NSMutableString stringWithString:@"Escapable: "];
    MazeBoxCell *lastCell = [pathArray lastObject];
    for (int i = (int)(pathArray.count - 2); i >= 0; i--){
        MazeBoxCell *currentCell = pathArray[i];
        if (currentCell.x > lastCell.x){
            [string appendString:@"E"];
        }
        else if (currentCell.x < lastCell.x){
            [string appendString:@"W"];
        }
        else if (currentCell.y > lastCell.y){
            [string appendString:@"S"];
        }
        else if (currentCell.y < lastCell.y){
            [string appendString:@"N"];
        }
        else if (currentCell.z > lastCell.z){
            [string appendString:@"U"];
        }
        else {
            [string appendString:@"D"];
        }
        lastCell = currentCell;
    }
    return string;
}

@end
