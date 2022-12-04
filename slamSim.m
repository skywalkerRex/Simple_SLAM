load slamRobotTrajectory.mat 

w = vrworld('slamSimulatedWorld.x3d');
open(w);

vrf = vrfigure(w);

robotVRNode = vrnode(w,'Robot');
robotVRNode.children.translation = [trajectory(1,1) 0 trajectory(1,2)];
robotVRNode.children.rotation = [0 1 0 0];

lidarVRNode = vrnode(w,'LIDAR_Sensor');
angles  = 180:-1.5:-178.5;
angles = deg2rad(angles)';

pause(1);

maxLidarRange = 8;
mapResolution = 150;
mapSearchRange = mapResolution / 10;
mapSize = mapResolution * 2;
robotSlamObj = slamObj(maxLidarRange, mapResolution, mapSearchRange, mapSize);
controlRate = rateControl(10);

firstLoopClosure = false;
scans = cell(length(trajectory),1);
posArray = zeros(200, 2);

scanfig = figure();
mapfig = figure();
for i=1:length(trajectory)
    % Use translation property to move the robot. 
    robotVRNode.children.translation = [trajectory(i,1) 0 trajectory(i,2)];
    vrdrawnow;
    
    % Read the range readings obtained from lidar sensor of the robot.
    range = lidarVRNode.pickedRange;
    
    % The simulated lidar readings will give -1 values if the objects are
    % out of range. Make all these value to the greater than
    % maxLidarRange.
    range(range==-1) = maxLidarRange+2;

    % Create a lidarScan object from the ranges and angles. 
    robotSlamObj = addNode(robotSlamObj, range, angles);

    disp("Curr Position is ");
    disp(robotSlamObj.m_currPos);
    posArray(i, :) = robotSlamObj.m_currPos;
    
    hold on;
    figure(scanfig), imagesc(robotSlamObj.m_Map);
    figure(mapfig), plot(posArray(:,1), posArray(:,2), 'or')
    xlim([min(posArray(:,1))-2 max(posArray(:,1))+2])
    ylim([min(posArray(:,2))-2 max(posArray(:,2))+2])
    hold off;

    waitfor(controlRate);
end
figure(scanfig), imagesc(robotSlamObj.m_Map);
close(vrf);
close(w);
pause(1);