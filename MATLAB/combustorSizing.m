clc;clear;close all


% AE 435 - COMBUSTOR SIZING
% Run Dong - J.A.R.-Tech
% Calculations 

% TASKS
% - find volume, cross-sectional areas, Mach numbers
% - Estimated loss
% - Expected loading 

FARstoich = 0.067; % for jet fuels

% Equivalence Ratios

FAR = 0.0215; % GASTURB

EquivalenceRatio = FAR/FARstoich;
% If >1 = rich combustion; if <1 = lean combustion

% Combustor Reference Quantities (GASTURB)

mdot3 = 18.614; % kg/s
rho3 = 5.83021; % kg/m^3
Pt4 = 1222.28;  % kPa
Pt3 = 1286.61;  % kPa
R = 287;        % Gas constant
Tt3 = 753.617;  % K
Vref = 108.06;  % m/s
gamma = 1.4;

% Combustor Pressure loss
% - Can assume dPt/Pt ~ 5-6 %

dPtpt = -0.05; 

% Calculations

qref = (rho3*Vref^2)/2;                 % m^3/s
Mref = Vref/sqrt(gamma*R*Tt3);          % no units
PressureLossCoeff = (Pt4-Pt3)/qref;     % no units
Aref = sqrt(((R/2)*(mdot3*(sqrt(Tt3)/Pt3))^2*PressureLossCoeff)/dPtpt);
Vref = mdot3/(rho3*Aref);               % m/s

% Combustor Loading

Aliner = 0.60*Aref;
LHV = 43.15*10^6;
Dliner = 2*sqrt(Aliner/pi);
VolumeLiner = (pi*Dliner^3)/6;

combustorloading = mdot3/(VolumeLiner*(Pt3^1.8)*10^0.00145*(Tt3-400));

% Displays



