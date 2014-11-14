MazeBox
=======

Simple shortest path solver that works as follows:
- Takes as input text that describes the 3d maze's configuration
- When the solve button is pressed, generates shortest path from beginning to end of the maze.

Input is of the form:
- first line is # of levels (height)
- then there is a blank row
- then each level is a set of lines, each with either '.', 'E', 'B', or '#'.
- '.' can go to cell, '#' cannot go to cell, 'E' end of maze, 'B' beginning of maze.
- Each level is separated by a space.

The UI is extremely barebones as that's not the focus of this project.
