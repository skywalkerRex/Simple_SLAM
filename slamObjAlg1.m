classdef slamObjAlg1 < slamObj
    methods
        function obj = addNode(obj, range, angle) % Add New Lidar result
            obj.m_prevScan = obj.m_currScan;
            obj.m_currScan = zeros(obj.m_resolution);
            
            for i = 1:length(range) % Convert the Lidar Scan to down graded point map
                if (range(i) < obj.m_maxRange)
                    nodeX = (range(i) * cos(angle(i)))/obj.m_maxRange * (obj.m_resolution/2) + obj.m_resolution/2;
                    nodeY = (range(i) * sin(angle(i)))/obj.m_maxRange * (obj.m_resolution/2) + obj.m_resolution/2;
                    obj.m_currScan(round(nodeY), round(nodeX)) = 1;
                end
            end
            
            if not (obj.m_isFirst) 
                % init the map with start point
                obj.m_currPos(1) = 0;
                obj.m_currPos(2) = 0;
                obj.m_isFirst = true;
            else
                % Iterate the new result with the previous scan to check the moveing distance
                minDiff = obj.m_resolution * obj.m_resolution;
                currOffSet = zeros(1,2);
                for i = (-obj.m_maxSearch):obj.m_maxSearch
                    for j = (-obj.m_maxSearch):obj.m_maxSearch
                        shiftScan = matrixShift(obj.m_currScan, i, j);
                        diffMatrix = shiftScan - obj.m_prevScan;
                        currDiff = sum(abs(diffMatrix), 'all');
                        if(currDiff < minDiff)
                            % imagesc(diffMatrix);
                            minDiff = currDiff;
                            currOffSet(1) = i;
                            currOffSet(2) = j;
                        end
                    end
                end
                obj.m_currPos = obj.m_currPos + currOffSet;
            end
            % After the localization result calculated, Update the map
            for i = 1:obj.m_resolution
                for j = 1:obj.m_resolution
                    mapX = i - obj.m_resolution/2 + obj.m_currPos(1) + obj.m_MapCenter(1);
                    mapY = j - obj.m_resolution/2 + obj.m_currPos(2) + obj.m_MapCenter(2);
                    currVal = obj.m_Map(mapY, mapX);
                    obj.m_Map(mapY, mapX) = currVal + obj.m_currScan(j,i);
                end
            end
        end
    end
end