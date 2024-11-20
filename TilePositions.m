function positions = TilePositions(clearance, min_edge_radius)

    side_length = 2 * min_edge_radius * tand(30);
    
    positions = zeros(2, 19);

    % Calculate and store horizontal positions of columns 1 & 5
    pos = 3 * side_length + sqrt(3) * clearance;
    for i = 1:3
        positions(1, i) = -pos;
    end
    for i = 17:19
        positions(1, i) = pos;
    end

    % Calculate and store horizontal positions of columns 2 & 4
    pos = 1.5 * side_length + 0.5 * sqrt(3) * clearance;
    for i = 4:7
        positions(1,i) = -pos;
    end
    for i = 13:16
        positions(1,i) = pos;
    end

    % Store horizontal position of column 3
    for i = 8:12
        positions(1,i) = 0;
    end

    % Calculate and store vertical positions of rows 1 and 9
    pos = 4 * min_edge_radius + 2 * clearance;
    positions(2,8) = pos;
    positions(2,12) = -pos;

    % Calculate and store vertical positions of rows 2 and 8
    pos = 3 * min_edge_radius + 1.5 * clearance;
    for i = [4 13]
        positions(2, i) = pos;
    end
    for i = [7 16]
        positions(2, i) = -pos;
    end

    % Calculate and store vertical positions of rows 3 and 7
    pos = 2 * min_edge_radius + clearance;
    for i = [1 9 17]
        positions(2,i) = pos;
    end
    for i = [3 11 19]
        positions(2,i) = -pos;
    end

    % Calculate and store vertical positions of rows 4 and 6
    pos = min_edge_radius + 0.5 * clearance;
    for i = [5 14]
        positions(2,i) = pos;
    end
    for i = [6 15]
        positions(2,i) = -pos;
    end

    % Store vertical position of row 5
    pos = 0;
    for i = [2 10 18]
        positions(2,i) = pos;
    end
end