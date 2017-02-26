clc; clear all; close all;

%These may or may not be necessary
%import matlab.io.*
%fptr = fits.openFile('spec-0266-51602-0014.fits')
fitsdisp('spec-0266-51602-0014.fits', 'Index', 2)

%This is the actual part of the code
info = fitsinfo('spec-0266-51602-0014.fits')
data = fitsread('spec-0266-51602-0014.fits', 'binarytable')
a = cell2mat(data);
flux = a(:,1);
x = 10.^(a(:,2));
hold on
plot(x,flux)
%plot(x,a(:,6),'red')