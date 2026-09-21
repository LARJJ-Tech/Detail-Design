clc;
clear;

% FIND: A0, A1, Ath

% INPUTS
% Constant assumptions
gamma = 1.4;
R = 287.05;

% [CRUISE; TOC; MANUEVER; CEILING; RTO; SLS] 
alt_m = [11582; 11582; 3048; 12802; 0; 0];
W_corr = [60.7704; 60.524; 55.288; 60.021; 53.371; 54.914];
M = [0.63 0.6 0.431916 1; 0.8 0.6 x x; 0.7 0.6 x x; 0.8 0.6 x x; 0.2 0.6 x x; 0 0.6 x x]; % Stations: [0 1 2 8]
A = [0.376589 0.161393]; % 2,8 ONLY, same across all conditions
Tt = [216.65 233.89 233.89 484.17; 216.65 244.44 244.44 500.02; 268.34 294.68 294.68 544.62; 216.65 244.44 244.44 506.92; 295.65 298.02 298.02 532.95; 288.15 288.15 288.15 527.87];
Pt = [20.647 26.981 26.711 60.354; 20.647 31.483 31.168 69.728; 69.682 96.663 95.696 186.042; 17.034 25.973 25.713 57.463; 101.325 104.191 103.149 190.295; 101.325 101.325 100.312 192.715];
Ath = [0.163027]; % same across all conditions
% altitude vector all alts in each condition
% corrected at all conditions
% Mach all cond., matrix each row diff condition
% same with A, Tt, Pt
% all rows in matrix
%% for loop,
% Altitude @ Cruise
alt_m = 11582.4; % cruise alt in m

% Finding atmos conditions @ cruise
[Ts,~,Ps,rho] = atmosisa(alt_m);

% Run used mass flow, not corrected so check that
W_corr = 60.7704; % corrected mass flow @ S2 (fan inlet)
W = 17.7809; % mass flow @ S2 (fan inlet)
% ^ make a calculation W = Wcorr*(Pt(1)/101325) / sqrt(Tt(1)/288.15)

% Values for Each Station
% Station [0 1 2 8]
M = [0.63 0.6 0.431946 1]; % S1 mach is an assumption
A = [0.376589 0.161393]; % 2, 8
Tt = [216.65 233.89 233.866 484.173];
Pt = [20.647 26.981 26.7115 60.3543];

% Isentropic Calculations
[~, TR, PR, ~, AR] = flowisentropic(gamma, M, 'Mach'); %finding the ratios
AR(4) = 0.999; % possibly an assumption according to Run, comes from that graph?
V = M*sqrt(gamma*R*Ts);

A = [W./(rho*V(1:2)) A];
D = 2*sqrt(A/pi);
D_in = D*12/0.3048;

% Mass Flow Ratio (Capture Ratio)
MFR = A(1)/A(2);

% Diffused Pressure Recovery
CPR = (Pt(3) - Pt(2))/(rho*V(2)^2/2);
CPRideal = 1 - (A(2)/A(3))^2;

% Nacelle Diameter calculations
Cpcrit = 1.1; % at M0 = 0.63 (assumption)
placeholder = 1+((gamma-1)/2);
AMA1 = 1 + ((2*MFR*((M(2)/M(1))*sqrt(placeholder*M(1)^2/placeholder*M(2)^2)-1) ...
    +2/(gamma-M(1)^2)*(placeholder*M(1)^2/placeholder*M(2)^2)^(gamma/gamma-1)-1))/(-Cpcrit);

NacelleArea = AMA1*A(2); % m2
NacelleDiameter = 2*sqrt(NacelleArea/pi); % m

% Inlet Area Calculations 
A1new = AR(4)*A(2); % m2
D1new = (2*sqrt(A1new/pi))*39.3701; % in
A2new = AR(4)*A(3);
D2new = (2*sqrt(A2new/pi))*39.3701; % in

Ath = 0.1630; % m^2, from cell L65 in comprehensiveMissionPerformanceData excel
Dth = (2*sqrt(Ath/pi))*39.3701; 

fprintf('\n')
fprintf('A1 = %.2f m^2\n\n A2 = %.2f m^2\n\n Ath = %.2f m^2\n\n', A1new, A2new, Ath)
fprintf('D1 = %.2f in\n\n D2 = %.2f in\n\n Dth = %.2f in\n\n', D1new, D2new, Dth)