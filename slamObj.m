classdef slamObj
    properties (Access = protected)
        m_isFirst % if the first point passed in
        m_MapCenter % Size of the map
        m_MapSize % Size of the map (Raise the map size if out of index)
        m_maxRange % max detecrange of device
        m_maxSearch; % maxSearch Distance
        m_resolution % Resolution of each scan
        m_prevScan % Previous Scan
        m_currScan % Current Scan
        m_Map % Map of all cuurent point
        m_currPos; % localization result
        m_origin; % Origin Point of the map
    end
    % properties
    % end
    methods
        function obj = slamObj(maxRange, resolution, searchRange, mapSize, origin) % Class Constructor
            obj.m_isFirst = false;
            obj.m_Map = zeros(mapSize);
            obj.m_MapSize = mapSize;
            obj.m_MapCenter = [mapSize/2, mapSize/2];
            obj.m_maxRange = maxRange;
            obj.m_maxSearch = searchRange;
            obj.m_resolution = resolution;
            obj.m_prevScan = zeros(resolution);
            obj.m_currScan = zeros(resolution);
            obj.m_currPos = zeros(1,2);
            obj.m_origin = origin;
        end

        function currPos = GetCurrLoc(obj)
            % newX = obj + obj.m_currPos(1)/(obj.m_resolution/2)*obj.m_maxRange;
            % newY = originY + obj.m_currPos(2)/(obj.m_resolution/2)*obj.m_maxRange;
            currPos =  obj.m_origin + obj.m_currPos./(obj.m_resolution/2).*obj.m_maxRange;
        end

        function map = GetMap(obj)
            map = obj.m_Map;
        end
    end
end