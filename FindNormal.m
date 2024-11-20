function [x, y, z] = FindNormal(ABx, ABy, ABz, ACx, ACy, ACz)
    
    % Calculate magnitude of each position vector
    magAB = sqrt(ABx^2 + ABy^2 + ABz^2);
    magAC = sqrt(ACx^2 + ACy^2 + ACz^2);

    % Calculate x, y, and z components of normal vector
    x = 0.5 * (ABx / magAB + ACx / magAC);
    y = 0.5 * (ABy / magAB + ACy / magAC);
    z = 0.5 * (ABz / magAB + ACz / magAC);

end