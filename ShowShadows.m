function ShowShadows(APCoords, UECoords, clearance)
    shadow_scale = 15;  % Higher scale = shorter shadows
    
    % Calculate precise dimensions
    f = 28e9;
    c = physconst('LightSpeed');
    lambda = c / f;
    min_edge_radius = 5 * lambda;
    
    positions = TilePositions(clearance, min_edge_radius);
    
    figure();
    hold on;
    
    for i = 1:19
        
        tileX = positions(1, i);
        tileY = positions(2,i);
        tileZ = 0;
    
        % Calculate x, y, and z components of position vectors
        ABx = APCoords(1) - tileX;
        ABy = APCoords(2) - tileY;
        ABz = APCoords(3) - tileZ;
        ACx = UECoords(1) - tileX;
        ACy = UECoords(2) - tileY;
        ACz = UECoords(3) - tileZ;
        
        magAC = sqrt(ACx^2 + ACy^2 + ACz^2);
        
        scaledACx = ACx / (magAC * shadow_scale);
        scaledACy = ACy / (magAC * shadow_scale);
        scaledACz = ACz / (magAC * shadow_scale);
        
        [nx, ny, nz] = FindNormal(ABx, ABy, ABz, ACx, ACy, ACz);
    
        [r, elev, azim] = NormalToPolar(nx, ny, nz);
    
        tile_vertices = TilePatch(tileX, tileY, [r elev azim], min_edge_radius);
    
        for j = 1:6
            if j == 6
                k = 1;
            else
                k = j + 1;
            end
        
            shadow_vertices = [
                tile_vertices(j,1), tile_vertices(j,2), tile_vertices(j,3);...
                ...
                tile_vertices(k,1), tile_vertices(k,2), tile_vertices(k,3);...
                ...
                tile_vertices(k,1) - scaledACx, ...
                tile_vertices(k,2) - scaledACy, ...
                tile_vertices(k,3) - scaledACz;...
                ...
                tile_vertices(j,1) - scaledACx, ...
                tile_vertices(j,2) - scaledACy, ...
                tile_vertices(j,3) - scaledACz
            ];
        
            shadow_face = [1 2 3 4];
            shadow = patch('Faces', shadow_face, 'Vertices', shadow_vertices);
            shadow.FaceColor = [94/255 101/255 112/255];
            shadow.FaceAlpha = 0.3;
            shadow.EdgeColor = 'none';
        end
    end
    
    xlabel('X', 'FontWeight','bold');
    ylabel('Y', 'FontWeight','bold');
    zlabel('Z', 'FontWeight','bold');
    daspect([1 1 1]);
    hold off;

end