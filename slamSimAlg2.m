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
mapResolution = 100;
%mapResolution = 80;
mapSearchRange = mapResolution / 10;
mapSize = mapResolution * 2;
robotOrigin = [-3, -2.8];
robotSlamObj = slamObjAlg2(maxLidarRange, mapResolution, mapSearchRange, mapSize, robotOrigin);
controlRate = rateControl(10);

posArray = zeros(length(trajectory), 2);

% Create Figures
localizationFig = figure();
figure(localizationFig), title('Localization Result');

tic;
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

    %disp("Curr Position is ");
    %disp(GetCurrLoc(robotSlamObj));
    posArray(i, :) = GetCurrLoc(robotSlamObj);
    
    hold on;
    displayVec = posArray;
    displayVec(i+1:end,:) = [];
    figure(localizationFig), plot(displayVec(:,1), displayVec(:,2), 'ob')
    figure(localizationFig), xlim([min(displayVec(:,1))-0.5 max(displayVec(:,1))+0.5])
    figure(localizationFig), ylim([min(displayVec(:,2))-0.5 max(displayVec(:,2))+0.5])
    set(gca,'Ydir','reverse')
    title('Localization Result');
    hold off;

    % waitfor(controlRate);
end

runTime = toc;

mapFig = figure();

hold on;
figure(mapFig), imagesc(GetMap(robotSlamObj));
set(gca,'YDir','normal') 
title('Mapping Result');
displayVec = posArray;
displayVec(i+1:end,:) = [];
figure(localizationFig), plot(displayVec(:,1), displayVec(:,2), 'ob', trajectory(:,1), trajectory(:,2), 'or')
sizeVector = [displayVec;trajectory];
figure(localizationFig), xlim([min(sizeVector(:,1))-0.5 max(sizeVector(:,1))+0.5])
figure(localizationFig), ylim([min(sizeVector(:,2))-0.5 max(sizeVector(:,2))+0.5])
set(gca,'Ydir','reverse')
title('Localization Result');
hold off;

disp("Run Analysis: ");
outDisp = sprintf('Total Run Time: %fs\n',runTime);
fprintf(outDisp);
outDisp = sprintf('Average Step Run Time: %fs\n', runTime/length(trajectory));
fprintf(outDisp);
tError = posArray - trajectory;
dErrorX = mean(tError(:,1));
dErrorY = mean(tError(:,2));
disp("Mean Error: ");
outDisp = sprintf('X: %f, Y: %s, Avg %f\n', dErrorX, dErrorY, (dErrorX+dErrorY));
fprintf(outDisp);

close(vrf);
close(w);
pause(1);