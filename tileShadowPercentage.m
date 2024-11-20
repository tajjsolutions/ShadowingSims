close all
clc

f = 28e9;
c = physconst('LightSpeed');
lambda = (c / f) * 100;

min_edge_radius = lambda * 5;    % Minimum distance from center of tile to edge (cm)
angle_RE = 45;          % Tilt angle of reflecting tile
angle_BE = angle_RE;    % Tilt angle of blocking tile
clearance = lambda/2;          % Separation distance between tile sides in neutral position (cm)
desired_ref_angle = 15; 
resolution = 0.1;

side_length = 2 * min_edge_radius * tand(30);

% Iterate over tile position along y axis
% For each point along y axis, find points between centerline and tile edge
% For each of those points, determine if maximum reflection angle > desired
num_rows = (2 * min_edge_radius / resolution);
num_rows = cast(num_rows, "uint16");
num_cols = (2 * side_length / resolution); 
num_cols = cast(num_cols, "uint16");
tile_max_ref = zeros(num_rows, num_cols);

row = 0;
col = 0;
num_blocked = 0;
num_clear = 0;

for y = min_edge_radius : -resolution : (0.5 * clearance)
    
    row = row + 1;
    %fprintf("\nRow: %d | ", row);

    lower_bound_top = y * (side_length / (2 * min_edge_radius)) - side_length;
    upper_bound_top = side_length - (side_length / (2* min_edge_radius)) * y;
    lower_bound_bottom = -(side_length / (2 * min_edge_radius)) * y - side_length;
    upper_bound_bottom = y * (side_length / (2 * min_edge_radius)) + side_length;

    % ===== Model top left tile quadrant =====

    col = 1;

    for r = -side_length : resolution : 0 - resolution
        if r >= lower_bound_top
            h_RE = abs(r) * sind(angle_RE);
            h_BE = abs(lower_bound_top) * sind(angle_BE);
            d_RE = abs(r) - abs(r) * cosd(angle_RE);
            d_BE = abs(lower_bound_top) - abs(lower_bound_top) * cosd(angle_BE); 
            
            d_EE = r - d_RE + upper_bound_top + clearance + d_BE;
            h_EE =  h_BE - h_RE;
            
            refl_angle_max = 90 - angle_RE - atand(h_EE ./ d_EE);

            if desired_ref_angle < refl_angle_max
                tile_max_ref(row,col) = 2;
                num_clear = num_clear + 1;
            else 
                tile_max_ref(row,col) = 1;
                num_blocked = num_blocked + 1;
            end
        end
        col = col + 1;
    end

    % ===== Model top right tile quadrant =====
    
    col = side_length / resolution;
    %fprintf("\n");
    col = cast(col, "uint16");

    for r = 0 : resolution : side_length
        if r <= upper_bound_top
            h_RE = abs(r) * sind(angle_RE);
            h_BE = abs(lower_bound_top) * sind(angle_BE);
            d_RE = abs(r) - abs(r) * cosd(angle_RE);
            d_BE = abs(lower_bound_top) - abs(lower_bound_top) * cosd(angle_BE); 
            
            d_EE = (upper_bound_top - r) + d_RE + clearance + d_BE;
            h_EE =  h_BE + h_RE;
            
            refl_angle_max = 90 - angle_RE - atand(h_EE ./ d_EE);
            
            if desired_ref_angle < refl_angle_max
                tile_max_ref(row,col) = 2;
                num_clear = num_clear + 1;
            else 
                tile_max_ref(row,col) = 1;
                num_blocked = num_blocked + 1;
            end
        end
        col = col + 1;
    end
end

for y = (0.5 * clearance) - resolution : -resolution : -(0.5 * clearance)
    
    row = row + 1;

    lower_bound_top = y * (side_length / (2 * min_edge_radius)) - side_length;
    upper_bound_top = side_length - (side_length / (2* min_edge_radius)) * y;
    lower_bound_bottom = -(side_length / (2 * min_edge_radius)) * y - side_length;
    upper_bound_bottom = y * (side_length / (2 * min_edge_radius)) + side_length;

    col = 1;

    for r = -side_length : resolution : side_length 
        if (y > 0)
            if (lower_bound_top <= r) && (r <= upper_bound_top)
                tile_max_ref(row,col) = 2;
                num_clear = num_clear + 1;
            end
        elseif (y == 0)
            tile_max_ref(row,col) = 2;
            num_clear = num_clear + 1;
        elseif (y < 0) 
            if (lower_bound_bottom <= r) && (r <= upper_bound_bottom)
                tile_max_ref(row,col) = 2;
                num_clear = num_clear + 1;
            end
        end
        col = col + 1;
    end
end 

for y = -(0.5 * clearance) - resolution : -resolution : -min_edge_radius

    row = row + 1;

    lower_bound_top = y * (side_length / (2 * min_edge_radius)) - side_length;
    upper_bound_top = side_length - (side_length / (2* min_edge_radius)) * y;
    lower_bound_bottom = -(side_length / (2 * min_edge_radius)) * y - side_length;
    upper_bound_bottom = y * (side_length / (2 * min_edge_radius)) + side_length;

    % ===== Model bottom left tile quadrant =====
    
    col = 1;

    for r = -side_length : resolution : 0 - resolution
        if r >= lower_bound_bottom
           
            h_RE = abs(r) * sind(angle_RE);
            h_BE = abs(lower_bound_bottom) * sind(angle_BE);
            d_RE = abs(r) - abs(r) * cosd(angle_RE);
            d_BE = abs(lower_bound_bottom) - abs(lower_bound_bottom) * cosd(angle_BE); 
            
            d_EE = r - d_RE + upper_bound_bottom + clearance + d_BE;
            h_EE =  h_BE - h_RE;
            
            refl_angle_max = 90 - angle_RE - atand(h_EE ./ d_EE);

            if desired_ref_angle < refl_angle_max
                tile_max_ref(row,col) = 2;
                num_clear = num_clear + 1;
            else 
                tile_max_ref(row,col) = 1;
                num_blocked = num_blocked + 1;
            end
        end
        col = col + 1;
    end

    % ===== Model bottom right tile quadrant =====
    
    col = side_length / resolution;
    col = cast(col, "uint16");
    
    for r = 0 : resolution : side_length 
        if r <= upper_bound_bottom
            h_RE = abs(r) * sind(angle_RE);
            h_BE = abs(lower_bound_bottom) * sind(angle_BE);
            d_RE = abs(r) - abs(r) * cosd(angle_RE);
            d_BE = abs(lower_bound_bottom) - abs(lower_bound_bottom) * cosd(angle_BE); 
            
            d_EE = (upper_bound_bottom - r) + d_RE + clearance + d_BE;
            h_EE =  h_BE + h_RE;
            
            refl_angle_max = 90 - angle_RE - atand(h_EE ./ d_EE);

            if desired_ref_angle < refl_angle_max
                tile_max_ref(row,col) = 2;
                num_clear = num_clear + 1;
            else 
                tile_max_ref(row,col) = 1;
                num_blocked = num_blocked + 1;
            end
        end
        col = col + 1;
    end
end

avg_blockage = (num_blocked / (num_clear + num_blocked)) * 100;
fprintf("Percentage of Tile Blocked: %.2f%%\n", avg_blockage);

figure();
h = heatmap(tile_max_ref);

h.Title = 'Shadowing of Hexagonal Reflective Tile';
h.XLabel = 'X';
h.YLabel = 'Y';
h.GridVisible = "off";
Ax = gca;
Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
Ax.YDisplayLabels = nan(size(Ax.YDisplayData));