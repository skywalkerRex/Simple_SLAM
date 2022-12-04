# Simple_SLAM

A simple SLAM alogorithm mplemented with matlab

## Approach

This algorithm is intended to do SLAM based on Lidar data and without odometry sensor.

From Lidar sensor, we could get a data includes 240 sets of data with range and radius. Those data demonstrates the Lidar detect data around the robot.

In order to do the SLAM computation, transfering Lidar data into Cartesian coordinate and mapping into a customized resoultion output is easier computation.
After getting the second set of data. By looping all the direction of to find out the difference between curren vs previous to determine which direction does the robot moved.

To collect a comperhensive mapping data, the robot need to finish a loop running in the area. By cumulating the data, finally we could get the map data of the current space.

## Result

### Localization Result

![Localization Result](https://github.com/skywalkerRex/Simple_SLAM/blob/main/result/Localization_Result.jpg?raw=true)

### Mapping Result

![Mapping Result](https://github.com/skywalkerRex/Simple_SLAM/blob/main/result/Mapping_Result.jpg?raw=true)
