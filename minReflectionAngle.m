close all
clear all
clc

min_edge_radius = 5;    % Minimum distance from center of tile to edge (cm)
angle_RE = 35;           % Tilt angle of reflecting tile
angle_BE = angle_RE;    % Tilt angle of blocking tile
clearance = 1;          % Separation distance between tile sides in neutral position (cm)

side_length = 2 .* min_edge_radius .* tand(30);

h_RE = side_length .* sind(angle_RE);
h_BE = side_length .* sind(angle_BE);
d_RE = side_length - side_length .* cosd(angle_RE);
d_BE = side_length - side_length .* cosd(angle_BE); 

d_EE = 2 .* side_length - side_length .* cosd(angle_RE) - side_length .* cos(angle_BE) + clearance;
h_EE = side_length .* sind(angle_RE) + side_length .* sind(angle_BE); 

refl_angle_max = 90 - angle_RE - atand(h_EE ./ d_EE);

fprintf("Minimum Edge Radius: %d cm\n", min_edge_radius);
fprintf("Angle of Reflecting Tile: %d deg\n", angle_RE);
fprintf("Angle of Blocking Tile: %d deg\n", angle_BE);
fprintf("Separation Between Tiles: %d cm", clearance); 
fprintf("Side Length: %.2f cm\n", side_length);

fprintf("\nMax Reflection Angle Before Shadowing: %.2f \n", refl_angle_max);