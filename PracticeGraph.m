clc; clear all; close all;
[num, txt]=xlsread('hygdata_v3.csv','R:W')
scatter3(num(:,1), num(:,2), num(:,3), 7, 'black', 'filled', 'square')
x = num(:,1);
y = num(:,2);
z = num(:,3);
vx = num(:,4);
vy = num(:,5);
vz = num(:,6);

for i = 1:1000000000
    x = x+100000000*vx;
    y = y+100000000*vy;
    z = z+100000000*vz;
    scatter3(x(:), y(:), z(:), 7, 'black', 'filled', 'square')
    F=getframe;
    imshow(F.cdata);
end