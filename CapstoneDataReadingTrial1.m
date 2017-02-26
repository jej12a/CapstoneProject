clc; clear all; close all;
[num, txt]=xlsread('HYGdata_v3.xlsx','R:T');
scatter3(num(:,1), num(:,2), num(:,3), 7, 'black', 'filled', 'square')