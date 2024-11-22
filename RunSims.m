close all; clear; clc;

% ShowShadows(APCoords, UECoords, clearance);
% VisualizeSystem(APCoords, UECoords, clearance);
% ShowTileNormals(APCoords, UECoords, clearance);

% Coordinates in meters
APCoords = [-5 0 5];
UECoords = [6 1.76 3]; % Audience interaction: # b/t 1-10, 0-2, 1-10
clearance = 0.01;

VisualizeSystem(APCoords, UECoords, clearance);

% Coordinates in meters
APCoords = [-5 0 5];
UECoords = [5 0 5];
clearance = 0.01;

close all;

% Ideal case, show each visual
VisualizeSystem(APCoords, UECoords, clearance);
close all;
ShowTileNormals(APCoords, UECoords, clearance, 1);
close all;
ShowShadows(APCoords, UECoords, clearance);
close all

% Show wider spacing
clearance = 0.05;
ShowTileNormals(APCoords, UECoords, clearance, 0.5);
ShowShadows(APCoords, UECoords, clearance);
close all

% Close up to show satellite dish effect
APCoords = [-5 0 5];
UECoords = [0.5 0 0.5];
clearance = 0.01;

ShowTileNormals(APCoords, UECoords, clearance, 0.5);
ShowShadows(APCoords, UECoords, clearance);
close all

% Show Shadowing
APCoords = [-5 0 5];
UECoords = [1 1.5 1];

ShowShadows(APCoords, UECoords, clearance);

close all