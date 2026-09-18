%% INPUTS (for cruise which has highest mass flow)

clc;
clear;

% FIND: A0, A1, Ath, A*

%% INPUTS (for cruise which has highest mass flow)

% Constant assumptions
gamma = 1.4;
R = 287.05;

% Altitude @ Cruise
alt_ft = 11582.4; % cruise alt in ft
alt_m = alt_ft*0.3048; % cruise alt in m

% Finding atmos conditions @ cruise
[Ts,~,Ps,rho] = atmosisa(alt_m);

% Run used mass flow, not corrected so check that
W2_corr = 60.7704; % corrected mass flow @ S2 (fan inlet)
W2 = 17.7809; % mass flow @ S2 (fan inlet)

% M1 Calculation
% Use comprehensiveMissionPerformance excel
% Cell L37 = Pt1, L35 = Ps1
% Got M1 =0.630

% Values for Each Station
% Station [0 1 2 8]
M = [0.63 0.63 0.431946 1]; % get S1 Mach by using isentropic conditions
A = [?? ?? 0.376589 0.161393];
Tt = [Ts ?? 233.866 484.173]
Pt = [26.7115 60.3543]

% Isentropic Calculations
[~, TR, PR, ~, AR] = flowisentropic(gamma, M, 'Mach'); %finding the ratios
AR(4) = 0.999; % possibly an assumption according to Run, comes from that graph?
Tt = [Ts./TR(1) Ts./TR(1) ttinstrumentdepthupdate];
Pt = [Ps./PR(1:2) Pt];
V = M*sqrt(gamma*R*Ts);


A0 =
A1 =

gamma = 

% Mass flow capture ratio

MFR = A0/A1

% Area ratio

A0overA1 = (M1/M0)*(((1+((gamma-1)/2)M0^2))/(1+((gamma-1)/2)M1^2))^((gamma+1)/(2(gamma-1)))

%% Run Code

% W = Wcorr*(Pt(1)/101325) / sqrt(Tt(1)/288.15);
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

Mthroat = 0.75; % given by Dr. Luis
[~,~,~,~,ARthroat] = flowisentropic(gamma,Mthroat,'mach');
Athroatnew = ARthroat*A(4); 
Dthroatnew = (2*sqrt(Athroatnew/pi))*39.3701; 

fprintf('\n')
fprintf('A1 = %.2f m^2\n\n A2 = %.2f m^2\n\n Ath = %.2f m^2\n\n', A1new, A2new, Athroatnew)
fprintf('D1 = %.2f in\n\n D2 = %.2f in\n\n Dth = %.2f in\n\n', D1new, D2new, Dthroatnew)