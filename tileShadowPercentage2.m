close all
clc

f = 28e9;
c = physconst('LightSpeed');
lambda = (c / f) * 100;
clearance = lambda/2;          % Separation distance between tile sides in neutral position (cm)
desiredRefAngle = 45; 
resolution = 0.1;

angles = 0 : 45;
percent_blockage = zeros(size(angles));

for i = 1 : 46

    percent_blockage(i) = HorizontalBlockage(angles(i), angles(i), desiredRefAngle);

end

figure();
plot(angles, percent_blockage, LineWidth=1.5);
title(sprintf("Tile Shadowing with %.2f cm Clearance", clearance));
xlabel("Angle ({\circ})");
ylabel("Percentage of Tile Blocked");