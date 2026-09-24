% FIND: A0, A1, Ath
clc;
clear;

% INPUTS
% Constant assumptions
gamma = 1.4;
R = 287.05;

% [CRUISE; TOC; MANUEVER; CEILING; RTO; SLS] 
alt_m = [11582; 
         11582; 
         3048; 
         12802; 
         0; 
         0];
W_corr = [60.7704; 
          60.524;
          55.288; 
          60.021; 
          53.371; 
          54.914];
% Stations: [0 1 Throat 2 8] ADD IN THROAT STATION LATER
M = [0.63 0.6 0.431916 1;
     0.8  0.6 0.42975  1; 
     0.7  0.6 0.384309 1; 
     0.8  0.6 0.425227 1; 
     0.2  0.6 0.368403 1; 
     0    0.6 0.381166 1]; 
A = [0.376589 0.161393]; % Stations 2,8 ONLY, same across all conditions
Tt = [216.65 233.89 233.89 484.17; % temperature would be the same as stations 1 and 2
      216.65 244.44 244.44 500.02; 
      268.34 294.68 294.68 544.62; 
      216.65 244.44 244.44 506.92; 
      295.65 298.02 298.02 532.95; 
      288.15 288.15 288.15 527.87];
Pt = [20.647 26.981 26.711 60.354; % INLET PRESSURE loss factor at inlet lip, can apply that to find pressure 
      20.647 31.483 31.168 69.728; 
      69.682 96.663 95.696 186.042; 
      17.034 25.973 25.713 57.463; 
      101.325 104.191 103.149 190.295; 
      101.325 101.325 100.312 192.715];
Ath = 0.163027; % m^2, same across all conditions, from cell L65 in comprehensiveMissionPerformanceData excel

%% For Loop
for k=1:height(M)

    % Finding atmos conditions @ cruise
    [Ts,~,Ps,rho] = atmosisa(alt_m(k));

    % Find Mass Flow
    W = W_corr(k)*(Pt(k,3)/101.325)/sqrt(Tt(k,3)/288.15);

    % Isentropic Calculations
    [~, TR, PR, ~, AR] = flowisentropic(gamma, M(k,:), 'Mach'); %finding the ratios
    AR(4) = 0.999; % possibly an assumption according to Run, comes from that graph?
    V = M(k,:)*sqrt(gamma*R*Ts);

    Anew = [W./(rho*V(1:2)) A];
    D = 2*sqrt(Anew/pi);
    D_in = D*12/0.3048;

    % Mass Flow Ratio (Capture Ratio)
    MFR = Anew(1)/Anew(2);

    % Diffused Pressure Recovery
    CPR = (Pt(k,3) - Pt(k,2))/(rho*V(2)^2/2);
    CPRideal = 1 - (Anew(2)/Anew(3))^2;

    % Nacelle Diameter calculations
    Cpcrit = 1.1; % at M0 = 0.63 (assumption)
    placeholder = 1+((gamma-1)/2);
    AMA1 = 1 + ((2*MFR*((M(k,2)/M(k,1))*sqrt(placeholder*M(k,1)^2/placeholder*M(k,2)^2)-1) ...
        +2/(gamma-M(k,1)^2)*(placeholder*M(k,1)^2/placeholder*M(k,2)^2)^(gamma/gamma-1)-1))/(-Cpcrit);

    NacelleArea = AMA1*Anew(2); % m2
    NacelleDiameter = 2*sqrt(NacelleArea/pi); % m

    % Inlet Area Calculations
    A1new(k) = AR(4)*Anew(2); % m2
    D1new(k) = (2*sqrt(A1new(k)/pi))*39.3701; % in
    A2new(k) = AR(4)*Anew(3);
    D2new(k) = (2*sqrt(A2new(k)/pi))*39.3701; % in

    Dth = (2*sqrt(Ath/pi))*39.3701;

    fprintf('\n')
    fprintf('A1 = %.2f m^2\n\n A2 = %.2f m^2\n\n Ath = %.2f m^2\n\n', A1new(k), A2new(k), Ath)
    fprintf('D1 = %.2f in\n\n D2 = %.2f in\n\n Dth = %.2f in\n\n', D1new(k), D2new(k), Dth)
    fprintf('\n\n--------------\n\n')

end