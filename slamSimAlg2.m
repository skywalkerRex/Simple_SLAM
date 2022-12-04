load testTrajectory.mat 

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
mapResolution = 500;
%mapResolution = 80;
mapSearchRange = mapResolution / 20;
mapSize = mapResolution * 2;
robotSlamObj = slamObjAlg2(maxLidarRange, mapResolution, mapSearchRange, mapSize);
controlRate = rateControl(10);

posArray = zeros(200, 2);

% Create Figures
mapFig = figure();
localizationFig = figure();
figure(localizationFig), title('Localization Result');

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

    % Add new scan to SLAM Object
    robotSlamObj = addNode(robotSlamObj, range, angles);

    disp("Curr Position is ");
    disp(GetCurrLoc(robotSlamObj));
    posArray(i, :) = GetCurrLoc(robotSlamObj);
    
    hold on;
    figure(mapFig), imagesc(GetMap(robotSlamObj));
    set(gca,'YDir','normal') 
    title('Mapping Result');
    figure(localizationFig), plot(posArray(:,1), posArray(:,2), 'or')
    figure(localizationFig), xlim([min(posArray(:,1))-mapSearchRange max(posArray(:,1))+mapSearchRange])
    figure(localizationFig), ylim([min(posArray(:,2))-mapSearchRange max(posArray(:,2))+mapSearchRange])
    hold off;

    % waitfor(controlRate);
end

close(vrf);
close(w);
pause(1);