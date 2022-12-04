function position = getCurrPosition(currPosition, currScan, prevScan, boardSize, searchSize)
    [currX, currY] = find(currScan == 1);
    currObstacleList = [currX, currY];
    [prevX, prevY] = find(prevScan == 1);
    prevObstacleList = [prevX, prevY];
    vectorList = getVectorList(currObstacleList, prevObstacleList, boardSize, searchSize);
    if isempty(vectorList)
        position = currPosition;
    else
        vactor = getVactor(vectorList);
        position = getPosition(currPosition, vactor);
    end
end

function vactorList = getVectorList(currPointList, prevPointList, boardSize, searchSize)
    vactorList = [];
    row = 0;
    tempPrevPointList = prevPointList;
    for index = 1 : length(currPointList)
        tempCurrPoint = currPointList(index, :);
        tempPosition = findClosestPosition(tempCurrPoint, tempPrevPointList, boardSize, searchSize);
        if ~isempty(tempPosition)
            tempDistance = getDistance(tempCurrPoint, tempPosition);
            if tempDistance ~= 0
                row = row + 1;
                vactorList(row, 1) = getDirection(tempCurrPoint, tempPosition);
                vactorList(row, 2) = tempDistance;
            end
        end
    end
end

function vactor = getVactor(vactorList)
    [vactor(1), time] = mode(vactorList(:, 1), "all");
    vactor(2) = mode(vactorList(:, 2), "all");
    vactorList(vactorList == vactor) = [];
    [subVactor(1), subTime] = mode(vactorList(:,1), "all");
    subVactor(2) = mode(vactorList(:,2), "all");
    if subTime > 5
        vactor = (time * vactor + subTime * subVactor) / (time + subTime);
    end
end

function position = getPosition(currenPosition, vector)
    position(1) = round(currenPosition(1) + vector(2) * sin((vector(1) - pi/2)));
    position(2) = round(currenPosition(2) + vector(2) * cos((vector(1) - pi/2)));
end

function distance = getDistance(currenPoint, checkPoint)
    diff = (currenPoint - checkPoint) .^ 2;
    distance = sum(diff) .^ 0.5;
end

function direction = getDirection(currenPoint, lastPoint)
    xDiff = currenPoint(1) - lastPoint(1);
    yDiff = currenPoint(2) - lastPoint(2);
    direction = -atan2(xDiff, yDiff);
end

function closestPosition = findClosestPosition(currenPoint, checkPointList, boardSize, searchSize)
    closestPosition = [];
    min = boardSize;
    for index = 1 : length(checkPointList)
        tempPosition = checkPointList(index, :);
        tempDistance = getDistance(currenPoint, tempPosition);
        if tempDistance < min && tempDistance < searchSize
            min = tempDistance;
            closestPosition = tempPosition;
            if tempDistance == 0
                break;
            end
        end
    end
end



