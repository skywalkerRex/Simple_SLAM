function position = getCurrPosition(currPosition, currScan, prevScan, boardSize, searchSize)
    [currY, currX] = find(currScan == 1);
    currObstacleList = [currX, currY];
    [prevY, prevX] = find(prevScan == 1);
    prevObstacleList = [prevX, prevY];
    vectorList = getVectorList(currObstacleList, prevObstacleList, boardSize, searchSize);
    if isempty(vectorList)
        position = currPosition;
    else
        vector = getVector(vectorList);
        position = getPosition(currPosition, vector);
    end
end

function vectorList = getVectorList(currPointList, prevPointList, boardSize, searchSize)
    vectorList = zeros(length(currPointList),2);
    row = 0;
    for index = 1 : length(currPointList)
        tempCurrPoint = currPointList(index, :);
        tempPosition = findClosestPosition(tempCurrPoint, prevPointList, boardSize, searchSize);
        if ~isempty(tempPosition)
            tempDistance = getDistance(tempCurrPoint, tempPosition);
            if tempDistance ~= 0
                row = row + 1;
                vectorList(row, 1) = getDirection(tempPosition, tempCurrPoint);
                vectorList(row, 2) = tempDistance;
            end
        end
    end
    vectorList(row+1:end,:) = [];
end

function vector = getVector(vectorList)
    [vector(1), freq] = mode(vectorList(:, 1), "all");
    vector(2) = mode(vectorList(:, 2), "all");
    rmItem = vectorList(:, 1) == vector;
    vectorList(rmItem, :) = [];
    [subVector(1), secondFreq] = mode(vectorList(:,1), "all");
    subVector(2) = mode(vectorList(:,2), "all");
    if secondFreq > 10
        distance = ((secondFreq * vector(2)/freq) ^2 + (freq * subVector(2)/secondFreq) ^2) ^0.5;
        vector = (freq * vector + secondFreq * subVector) / (freq + secondFreq);
        vector(2) = distance;
    end
end

function position = getPosition(currenPosition, vector)
    position(1) = round(currenPosition(1) + vector(2) * cos(vector(1)));
    position(2) = round(currenPosition(2) + vector(2) * sin(vector(1)));
end

function distance = getDistance(currenPoint, checkPoint)
    diff = (currenPoint - checkPoint) .^ 2;
    distance = sum(diff) .^ 0.5;
end

function direction = getDirection(currenPoint, lastPoint)
    xDiff = currenPoint(1) - lastPoint(1);
    yDiff = currenPoint(2) - lastPoint(2);
    direction = atan2(yDiff, xDiff);
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



