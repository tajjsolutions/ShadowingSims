function PlotSpheres(APCoords, UECoords, scale)

    % Calculate graph limits based on input coordinates
    limit = 1 + max([abs(APCoords(1)), abs(APCoords(2)), abs(APCoords(3)),...
        abs(UECoords(1)), abs(UECoords(2)), abs(UECoords(3))]);

    % Generate Unit Sphere
    [x, y, z] = sphere;
    
    % Center sphere at AP Coords
    tx_sphere_x = x * scale + APCoords(1);
    tx_sphere_y = y * scale + APCoords(2);
    tx_sphere_z = z * scale + APCoords(3);
    
    % Plot sphere representing Transmitter
    tx = surf(tx_sphere_x, tx_sphere_y, tx_sphere_z);
    tx.FaceColor = [153/255 204/255 255/255];
    tx.EdgeColor = 'none';
    hold on;
    
    % Center another sphere at UE Coords
    rx_sphere_x = x * scale + UECoords(1);
    rx_sphere_y = y * scale + UECoords(2);
    rx_sphere_z = z * scale + UECoords(3);
    
    % Plot sphere representing Receiver
    rx = surf(rx_sphere_x, rx_sphere_y, rx_sphere_z);
    rx.FaceColor = [153/255 255/255 153/255];
    rx.EdgeColor = 'none';
    
    xlabel('X', 'FontWeight','bold');
    ylabel('Y', 'FontWeight','bold');
    zlabel('Z', 'FontWeight','bold');
    
    xlim([-limit limit]);
    ylim([-limit limit]);
    zlim([-1 limit]);
    daspect([1 1 1]);

end