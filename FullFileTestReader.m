clc; clear all; close all;

%Read all of the filenames

%Load directory and add path
projectdir = 'C:\Users\James\Documents\MATLAB\CapstoneProject\dr13\26'
addpath('dr13/26');

%Create dinfo
dinfo = dir(fullfile(projectdir, '*.fits'));
filenames = {dinfo.name};
filenames(1)

%Test read
for k = 1:2
    j = filenames(k)
    data = fitsread(filenames{k}, 'binarytable');
    a = cell2mat(data);
    flux = a(:,1);
    x = 10.^(a(:,2));
    hold on
    plot(x,flux)
end

%This is the actual part of the code
%data = fitsread('spec-0266-51602-0014.fits', 'binarytable')
%a = cell2mat(data);
%flux = a(:,1);
%x = 10.^(a(:,2));
%hold on
%plot(x,flux)
