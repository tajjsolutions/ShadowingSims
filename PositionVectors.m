function [ABx, ABy, ABz, ACx, ACy, ACz] ...
    = PositionVectors(TileCoords, APCoords, UECoords)

    ABx = APCoords(1) - TileCoords(1);
    ABy = APCoords(2) - TileCoords(2);
    ABz = APCoords(3) - TileCoords(3);
    ACx = UECoords(1) - TileCoords(1);
    ACy = UECoords(2) - TileCoords(2);
    ACz = UECoords(3) - TileCoords(3);
    
end