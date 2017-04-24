clc; clear all; close all;

%Read all of the filenames
%Load directory and add path
projectdir = 'C:\Users\James\Documents\MATLAB\CapstoneProject\dr13\26';
addpath('dr13/26');

%Create dinfo
dinfo = dir(fullfile(projectdir, '*.fits'));
filenames = {dinfo.name};

%Initialize scaling
largest = 0;

%Energy state energies (in eV)
%Hydrogen
H2 = 10.1988357; %n = 2 to find all Balmer lines
H3 = 12.0875051; %n = 3 for 3=>2 transition
H4 = 12.7485392; %n = 4 for 4=>2 transition
H5 = 13.0545016; %n = 5 for 5=>2 transition

%Sodium
Na3s1_2 = 0;
Na3p1_2 = 2.102297159;
Na3p3_2 = 2.104429184;

%Iron
Fe0 = 0;
Fe1 = 0;
Fe2 = 0;
Fe3 = 0;

%Full reader (this is the main chunk of the code)
for k = 2:2 %determines how many .fits to read and analyze
    %Access and store data in usable form
    info = fitsinfo(filenames{k}); %fits file info
    spec = fitsread(filenames{k}, 'binarytable'); %pull spectrum table
    data = fitsread(filenames{k}, 'binarytable',2); %pull distance/temp table
    b = cell2mat(spec); %save spectrum
    temp = cell2mat(data(107)); %temp
    ra = cell2mat(data(60));
    dec = cell2mat(data(61));
    redshift = cell2mat(data(64));
    red_error = cell2mat(data(65));
    h = 6.63e-34;  %planck's constant (SI units)
    c = 3e8;    %light speed (m/s)
    kb = 1.38065e-23;  %boltzmann's constant (SI units)
    
    %Pull data for Balmer 4=>2 and analyze
    x = 10.^(b(:,2));    %x-values in angstroms
    x_used = x(1030:1100);   %selection gaussian portion
    planck = ((2.*h.*c^2)./(x.^5)).*(1./(exp((h.*c)./(x.*kb.*temp))-1));    %Planck's Law
    flux = b(:,1);   %y-values
    flux = -1*flux;   %flip for gaussian analysis
    %flux = 
    flux_used = flux(1030:1100);  %select gaussian portion
    flux_min = min(flux_used); %Find minimum
    flux_used = flux_used - flux_min; %Adjust to zero
    a = [1, 4860,10000];  %give initial gaussian parameters
    [a,R,J,covB,MSE,ErrorModelInfo] = nlinfit(x_used,flux_used,'gauss',a);  %fit to gaussian
    if a(3) > 10^5;
        datastore(1,k) = 0;
    else
        ab_exc = a(3)/(1e7); %adjust excited abundance for line strength 
        ab_gr = ab_exc*exp((H3 - H2)/(kb*temp));
        datastore(1,k) = ab_exc + ab_gr;
    end
    if datastore(1,k) > largest
        largest = datastore(1,k);
    end
    
    %Plot of spectrum
    figure()
    hold on
    plot(x,flux); xlabel('Wavelength (Angstroms)'); ylabel('Flux (AU)')
    figure()
    plot(x(1600:1900),flux(1600:1900)) %This shows an iron line on spectrum 4
    
    %Plot of hydrogen line
    figure()
    hold on
    plot(x_used,flux_used)
    plot(x_used,gauss(a,x_used),'r')
    xlabel('Wavelength (Angstroms)'); ylabel('Flux (AU)'); legend('Data','Gaussian')
end

%Normalize and plot data
datastore = datastore/largest; %normalization
figure()
plot(datastore)
xlabel('Spectrum #'); ylabel('Abundance (AU)')