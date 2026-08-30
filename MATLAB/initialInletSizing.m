% AE 435 - Engine Inlet AE440 calculations

clearvars
close all
% clc
gamma = 1.4; R = 287.05;

alt_ft = [11582.4	13093.1	13757.8	3048	914.4	0];
W = [18.0163	17.0158	16.9205	49.2266	51.2401	55.0393];
M0 = [0.65	0.8	0.9	0.6	0.2	0];


A2 = [0.376];
Tt2 = [299.347	319.802	331.357	354.466	348.515	352.518];
Pt2 = [59.081	58.1266	58.9784	171.906	177.053	191.196];

A8 = [0.161];
Tt8 = [491.855	543.015	567.312	547.104	533.532	538.57];
Pt8 = [61.6416	61.3191	62.3758	177.82	182.674	197.171];


InleteData = zeros(length(alt_ft),6);

for ii = 1:length(alt_ft)

    % Atmospheric Conditions
    alt_m = alt_ft(ii) * 0.3048;
    [Ts,~,Ps,rho] = atmosisa(alt_m);

    % GASTURB Engine Stations (INPUTS)
    w =  W(ii);
    % St.  0          1           2           8
    M =   [M0(ii)     0.65        0.5        1];
    A =   [                       A2       A8];
    Tt =  [                       Tt2(ii)      Tt8(ii)];
    Pt =  [                       Pt2(ii)      Pt8(ii)];

    % Isentropic Calculations
    [~,TR,PR,~,AR] = flowisentropic(gamma,M,'mach');
    AR(4) = 0.9999;

    Tt = [Ts./TR(1) Ts./TR(1) Tt];
    Pt = [Ps./PR(1:2) Pt];
    V = M*sqrt(gamma*R*Ts);

    % W = Wcorr*(Pt(1)/101325) / sqrt(Tt(1)/288.15);
    A = [w./(rho*V(1:2)) A];
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

    InletData(ii,:) = [A1new, A2new, Athroatnew, D1new, D2new, Dthroatnew];

    fprintf('\n')
    fprintf('Our A1 area is %.2f m^2\n', A1new)
    fprintf('Our A2 area is %.2f m^2\n', A2new)
    fprintf('Our Athroat area is %.2f m^2\n', Athroatnew)
    fprintf('Our A1 diameter at cruise is %.2f inches\n', D1new)
    fprintf('Our A2 diameter at cruise is %.2f inches\n', D2new)
    fprintf('Our Athroat diameter at cruise is %.2f inches\n', Dthroatnew)
    fprintf('\n')

end