function [r, elevation, azimuth] = NormalToPolar(nx, ny, nz)

    % Convert Cartesian vector into polar vector
    r = sqrt(nx^2 + ny^2 + nz^2);
    elevation = rad2deg(atan(ny / nz));
    % azimuth = rad2deg(sign(n(3)) * acos(n(1) / sqrt(n(1)^2 + n(3)^2))) - 90;
    azimuth = rad2deg(atan(nx/nz));

    % Control for undefined values; occurs when z component of normal is 0
    if isnan(azimuth)
        azimuth = 0;
    end

end