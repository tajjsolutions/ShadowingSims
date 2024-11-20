function VisualizeSystem(APCoords, UECoords, clearance)

    figure();
    hold on;
    PlotSpheres(APCoords, UECoords, 0.3);
    
    % Calculate precise dimensions
    f = 28e9;
    c = physconst('LightSpeed');
    lambda = c / f;
    min_edge_radius = 5 * lambda;
    
    % Calculate and store positions of tile centers
    positions = TilePositions(clearance, min_edge_radius);
    
    % Loop to calculate normal vectors of all 19 tiles
    for i = 1:19
        % Extract tile position from positions matrix
        tile_coords = [positions(1,i), positions(2,i), 0]; % All tiles are on z plane
        
        % Calculate x, y, and z components of position vectors
        ABx = APCoords(1) - tile_coords(1);
        ABy = APCoords(2) - tile_coords(2);
        ABz = APCoords(3) - tile_coords(3);
        ACx = UECoords(1) - tile_coords(1);
        ACy = UECoords(2) - tile_coords(2);
        ACz = UECoords(3) - tile_coords(3);
    
        % Calculate normal vector for current tile
        [nx, ny, nz] = FindNormal(ABx, ABy, ABz, ACx, ACy, ACz);
        
        [r, elev, azim] = NormalToPolar(nx, ny, nz);
    
        % Generate and plot patch representation of current tile
        TilePatch(tile_coords(1), tile_coords(2), [r elev azim], min_edge_radius);
        
        % Plot Position Vectors
        AB = plot3([tile_coords(1), tile_coords(1)+ABx], ...
                   [tile_coords(2), tile_coords(2)+ABy], ...
                   [tile_coords(3), tile_coords(3)+ABz]);
        AB.Color = [153/255 204/255 255/255, 0.5];
    
        AC = plot3([tile_coords(1), tile_coords(1)+ACx], ...
                   [tile_coords(2), tile_coords(2)+ACy], ...
                   [tile_coords(3), tile_coords(3)+ACz]);
        AC.Color = [153/255 255/255 153/255, 0.5];
    
    end
    xlabel('X', 'FontWeight','bold');
    ylabel('Y', 'FontWeight','bold');
    zlabel('Z', 'FontWeight','bold');
    daspect([1 1 1]);
    hold off;

end