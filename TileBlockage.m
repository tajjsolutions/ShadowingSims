function blockage = TileBlockage(reflectorAngle, blockerAngle, desiredReflectionAngle)
    
    frequency = 28e9;               % Assume frequency of 28 GHz
    c = physconst('LightSpeed');
    lambda = (c / frequency) * 100;         % Find wavelength in cm

    minEdgeRadius = lambda * 5;   % Minimum distance from center of tile to edge (cm)
                                    % Length from edge-to-edge is 10x wavelength to avoid diffused reflections 
    clearance = lambda/2;           % Separation distance between tile sides in neutral position (cm)
                                    % Minimum of hlaf-wavelength to mitigate mutual coupling effects
    resolution = 0.1;
    sideLength = 2 * minEdgeRadius * tand(30);   % Calculate hexagon side length

    for i = 1 : 46
    
    % Iterate over tile position along y axis
    % For each point along y axis, find points between centerline and tile edge
    % For each of those points, determine if maximum reflection angle > desired
    numRows = (2 * minEdgeRadius / resolution);
    numRows = cast(numRows, "uint16");
    numCols = (2 * sideLength / resolution); 
    numCols = cast(numCols, "uint16");
    tileMaxRef = zeros(numRows, numCols);
    
    row = 0;
    numBlocked = 0;
    numClear = 0;

    for y = minEdgeRadius : -resolution : (0.5 * clearance)
        
        row = row + 1;
        %fprintf("\nRow: %d | ", row);
    
        lowerBoundTop = y * (sideLength / (2 * minEdgeRadius)) - sideLength;
        upperBoundTop = sideLength - (sideLength / (2* minEdgeRadius)) * y;
    
        % ===== Model top left tile quadrant =====
    
        col = 1;
    
        for r = -sideLength : resolution : 0 - resolution
            if r >= lowerBoundTop
                h_RE = abs(r) * sind(reflectorAngle);
                h_BE = abs(lowerBoundTop) * sind(blockerAngle);
                d_RE = abs(r) - abs(r) * cosd(reflectorAngle);
                d_BE = abs(lowerBoundTop) - abs(lowerBoundTop) * cosd(blockerAngle); 
                
                d_EE = r - d_RE + upperBoundTop + clearance + d_BE;
                h_EE =  h_BE - h_RE;
                
                reflAngleMax = 90 - reflectorAngle - atand(h_EE ./ d_EE);
    
                if desiredReflectionAngle < reflAngleMax
                    tileMaxRef(row,col) = 2;
                    numClear = numClear + 1;
                else 
                    tileMaxRef(row,col) = 1;
                    numBlocked = numBlocked + 1;
                end
            end
            col = col + 1;
        end
    
        % ===== Model top right tile quadrant =====
        
        col = sideLength / resolution;
        col = cast(col, "uint16");
    
        for r = 0 : resolution : sideLength
            if r <= upperBoundTop
                h_RE = abs(r) * sind(reflectorAngle);
                h_BE = abs(lowerBoundTop) * sind(blockerAngle);
                d_RE = abs(r) - abs(r) * cosd(reflectorAngle);
                d_BE = abs(lowerBoundTop) - abs(lowerBoundTop) * cosd(blockerAngle); 
                
                d_EE = (upperBoundTop - r) + d_RE + clearance + d_BE;
                h_EE =  h_BE + h_RE;
                
                reflAngleMax = 90 - reflectorAngle - atand(h_EE ./ d_EE);
                
                if desiredReflectionAngle < reflAngleMax
                    tileMaxRef(row,col) = 2;
                    numClear = numClear + 1;
                else 
                    tileMaxRef(row,col) = 1;
                    numBlocked = numBlocked + 1;
                end
            end
            col = col + 1;
        end
    end
    
    for y = (0.5 * clearance) - resolution : -resolution : -(0.5 * clearance)
        
        row = row + 1;
    
        lowerBoundTop = y * (sideLength / (2 * minEdgeRadius)) - sideLength;
        upperBoundTop = sideLength - (sideLength / (2* minEdgeRadius)) * y;
        lowerBoundBottom = -(sideLength / (2 * minEdgeRadius)) * y - sideLength;
        upperBoundBottom = y * (sideLength / (2 * minEdgeRadius)) + sideLength;
    
        col = 1;
    
        for r = -sideLength : resolution : sideLength 
            if (y > 0)
                if (lowerBoundTop <= r) && (r <= upperBoundTop)
                    tileMaxRef(row,col) = 2;
                    numClear = numClear + 1;
                end
            elseif (y == 0)
                tileMaxRef(row,col) = 2;
                numClear = numClear + 1;
            elseif (y < 0) 
                if (lowerBoundBottom <= r) && (r <= upperBoundBottom)
                    tileMaxRef(row,col) = 2;
                    numClear = numClear + 1;
                end
            end
            col = col + 1;
        end
    end 
    
    for y = -(0.5 * clearance) - resolution : -resolution : -minEdgeRadius
    
        row = row + 1;
    
        lowerBoundBottom = -(sideLength / (2 * minEdgeRadius)) * y - sideLength;
        upperBoundBottom = y * (sideLength / (2 * minEdgeRadius)) + sideLength;
    
        % ===== Model bottom left tile quadrant =====
        
        col = 1;
    
        for r = -sideLength : resolution : 0 - resolution
            if r >= lowerBoundBottom
               
                h_RE = abs(r) * sind(reflectorAngle);
                h_BE = abs(lowerBoundBottom) * sind(blockerAngle);
                d_RE = abs(r) - abs(r) * cosd(reflectorAngle);
                d_BE = abs(lowerBoundBottom) - abs(lowerBoundBottom) * cosd(blockerAngle); 
                
                d_EE = r - d_RE + upperBoundBottom + clearance + d_BE;
                h_EE =  h_BE - h_RE;
                
                reflAngleMax = 90 - reflectorAngle - atand(h_EE ./ d_EE);
    
                if desiredReflectionAngle < reflAngleMax
                    tileMaxRef(row,col) = 2;
                    numClear = numClear + 1;
                else 
                    tileMaxRef(row,col) = 1;
                    numBlocked = numBlocked + 1;
                end
            end
            col = col + 1;
        end
    
        % ===== Model bottom right tile quadrant =====
        
        col = sideLength / resolution;
        col = cast(col, "uint16");
        
        for r = 0 : resolution : sideLength 
            if r <= upperBoundBottom
                h_RE = abs(r) * sind(reflectorAngle);
                h_BE = abs(lowerBoundBottom) * sind(blockerAngle);
                d_RE = abs(r) - abs(r) * cosd(reflectorAngle);
                d_BE = abs(lowerBoundBottom) - abs(lowerBoundBottom) * cosd(blockerAngle); 
                
                d_EE = (upperBoundBottom - r) + d_RE + clearance + d_BE;
                h_EE =  h_BE + h_RE;
                
                reflAngleMax = 90 - reflectorAngle - atand(h_EE ./ d_EE);
    
                if desiredReflectionAngle < reflAngleMax
                    tileMaxRef(row,col) = 2;
                    numClear = numClear + 1;
                else 
                    tileMaxRef(row,col) = 1;
                    numBlocked = numBlocked + 1;
                end
            end
            col = col + 1;
        end
    end
    
    blockage = (numBlocked / (numClear + numBlocked)) * 100;

    end
end