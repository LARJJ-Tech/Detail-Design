clc;
clear;
close all

% FIND Volume, Cross-Sec Areas, Mach, Estimated Loss, Expected Loading
% Design at TOC - highest setting

% Also research emissions/pollution for comb temp range youre in
% Calculate loading based on primary zone, around 20% of the volume ish
% Film cooling

FARstoich = 0.067; % for jet fuels, assumption from Prop_Combustor.pdf Notes

% Equivalence Ratios
% From GasTurb -> Off Design -> Standard Maps -> engineCycle.CYM -> Mission
% (Run) -> Read -> Mission Folder -> constraints.MSN -> Run -> Click a cell 
% for TOC -> Details -> Find on stations page
FAR = 0.025869; 
EquivalenceRatio = FAR/FARstoich;
% If >1 = rich combustion; if <1 = lean combustion
% Jet turbines usually run lean

% Combustor Reference Quantities
%From GasTurb -> Off Design -> Standard Maps -> engineCycle.CYM -> Mission
% (Run) -> Read -> Mission Folder -> constraints.MSN -> Run -> Click a cell 
% for TOC -> Details -> Find on stations or summary page
mdot3 = 6.200;  % kg/s
rho3 = 3.37093; % kg/m^3
Pt4 = 573768;  % kPa
Pt3 = 604722;  % kPa
Tt3 = 612.31;  % K
Tt4 = 1600; % K [GET THIS FROM GASTURB CUZ RN ITS FILLER]
Vref = 108.06;  % m/s

gamma = 1.4;
R = 287;
LHV = 43.15*10^6;

dPtpt = -0.05; % comb press loss, can assume ~5-6% but can be ~7% for high speed engines

combustor_type = 'can'; % Combustor type: 'annular', 'can'
TR = Tt4 / Tt3; % Temp ratio
omega_hot = 1.3 * (TR - 1); % Hot loss coeff

% Selecting omega_cold based on combuster type
if strcmpi(combustor_type, 'can')
    omega_cold = 37;
    K_OTDF = -0.07;
elseif strcmpi(combustor_type, 'annular')
    omega_cold = 16;
    K_OTDF = -0.05;
else
    error('Unknown combustor type.');
end

qref = (rho3*Vref^2)/2; % kg/m^3 * m^2/s^2, kg/ms^2
PressureLossCoeff = (Pt4-Pt3)/qref;

Aref = sqrt(((R/2)*(mdot3*(sqrt(Tt3)/Pt3))^2*PressureLossCoeff)/dPtpt);

Aliner = 0.50*Aref;








%% NOT USING THIS BUT I'M KEEPING IT AROUND DO NOT TOUCH THIS


% Calculations
%Mref = Vref/sqrt(gamma*R*Tt3);          % no units
%Vref = mdot3/(rho3*Aref);               % m/s

% Combustor Loading
%Dliner = 2*sqrt(Aliner/pi);
%VolumeLiner = (pi*Dliner^3)/6;
%combustorloading = mdot3/(VolumeLiner*(Pt3^1.8)*10^0.00145*(Tt3-400));

%Dref = 2*sqrt(Aref/pi);
%D_in = Dref*12/0.3048;

%Dliner = 2*sqrt(Aliner/pi);
%Dliner_in = Dliner*12/0.3048;