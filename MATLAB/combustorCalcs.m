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
Pt3atm = Pt3/101300; % atm
Tt3 = 612.31;  % K
Tt4 = 1497.91; % K
Vref = 207.37;  % m/s
Tres = 0.003; % s
CombLoading = 150; % kg/s atm^1.8 m^3, [SPECIFY W VIDAL]

gamma = 1.4;
R = 287;
LHV = 43.15*10^6;

dPtpt = -0.05; % comb press loss, can assume ~5-6% but can be ~7% for high speed engines

TR = Tt4 / Tt3; % Temp ratio
omega_hot = 1.3 * (TR - 1); % Hot loss coeff
omega_cold = 16; % 37 for can, 16 for annular
K_OTDF = -0.05; %-0.07  for can, -0.05 for annular


% Aref and Aliner and Volume Calcs
qref = (rho3*Vref^2)/2; % kg/m^3 * m^2/s^2, kg/ms^2
PressureLossCoeff = (Pt4-Pt3)/qref;

Aref = sqrt(((R/2)*(mdot3*(sqrt(Tt3)/Pt3))^2*PressureLossCoeff)/dPtpt);
Dref = (2*sqrt(Aref/pi))*(12/0.3048); % in

Aliner = 0.50*Aref;
Dliner = (2*sqrt(Aliner/pi))*(12/0.3048); % in

VolRef = (pi*Dref^3)/6;
VolLiner = (pi*Dliner^3)/6;

Mref = Vref/sqrt(gamma*R*Tt3); % no units


% Flow Distribution Calcs


% Combustor Length Calcs

% Combustion Efficiency Calcs

% Liner Hole Total Area Calcs

%% NOT USING THIS BUT I'M KEEPING IT AROUND DO NOT TOUCH THIS

%combustorloading = mdot3/(VolumeLiner*(Pt3^1.8)*10^0.00145*(Tt3-400));
