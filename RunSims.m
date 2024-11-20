close all; clear; clc;

% Coordinates in meters
APCoords = [-5 0 5];
UECoords = [1 1.5 1];
clearance = 0.01;

ShowShadows(APCoords, UECoords, clearance);
VisualizeSystem(APCoords, UECoords, clearance);
ShowTileNormals(APCoords, UECoords, clearance);