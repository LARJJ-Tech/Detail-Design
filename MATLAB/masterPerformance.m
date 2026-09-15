%% Master Performance Equation Map
% TW = B/a{q/B WL^-1 * (k1[nB/q WL]^2 + k2[nB/q WL] + Cd0 + Cdr) + 1/V dz_dt}
%
%  alpha_T  : thrust lapse (normalised total pressure ratio, P_t / P_t_sl)
%  B        : throttle ratio (0-1)
%  Cd0      : zero-lift drag coefficient (Mach-dependent)
%  Cdr      : additional drag delta
%  dz_dt    : rate of climb
%  k1,k2    : induced drag coefficients
%  sg       : ground run, ft
%  TW       : thrust-to-weight ratio at sea level, static, full throttle
%  WL       : wing loading [N/m^2]

% Airframe Parameters
k1  = 0.18;
k2  = 0;
Cdr = 0;
B   = [0.95 0.80 0.85];
n   = [1.00 3.00 1.00];
% A   = [0.9875 ];

% Flight Parameters
M      = [0.63 0.7 0.8];
dz_dt  = [0.0 0.0 0.51];
W      = [];
alt_ft = [38000 10000 42000];
alt_m  = alt_ft * 0.3048;

% Atmosphere
[T, a, P, rho] = atmosisa(alt_m);
a   = a(:).';
P   = P(:).';
rho = rho(:).';
gamma = 1.4;

% Flight Conditions
V  = M  .* a;
q  = 0.5 .* rho .* V.^2;
alpha_T = thrustLapseDatatable(alt_ft,M);

Tt_Ts   = (1 + (gamma-1)/2 .* M.^2);
Pt_ps   = (1 + (gamma-1)/2 .* M.^2) .^ (gamma/(gamma-1));
Pt = Pt_ps .* P;
Tt = Tt_Ts .* T;
% alpha_T = (P ./ 101325) .* Pt_ps;

% Drag Polar
Cd0           = 0.014 * ones(size(M));
comp         = M > 0.8;
Cd0(comp)    = 0.014+(M(comp) -0.8)*0.035;
% Cd0(comp)    = 0.014 ./ sqrt(1 - M(comp).^2);

% Master Performance Equation
WL_lb  = 20:0.5:80;
WL     = WL_lb' * 47.8803;
TW  =   B./alpha_T .* ...
        (q./B .* WL.^-1 .* ...
        (k1.*(n.*B./q.*WL).^2 + k2.*(n.*B./q.*WL) + Cd0 + Cdr) ...
        + V.^-1 .* dz_dt);

% Take-off & Landing Performance
Vs = 51.4; % m/s
Mto = 0.2;
Bto = 1.00;
g = 9.80665;

Vr_Vs = 1.2;
Clm_to = 1.6;
Clm_ldg = 2.3;

dT = 10;
rho_ref = 1.225;
alpha_to = (1 + (gamma-1)/2 .* Mto^2) .^ (gamma/(gamma-1));
rho_to = 101.325e3/(287.1*(288.15+dT));
rho_ldg = 101.325e3/(287.1*(288.15+dT)); 

rwy_ft = 2150;
rwy_m = rwy_ft * 0.3048;
Tr = 3;
sg = rwy_m - Vr_Vs*Vs*Tr; 

TW_to  =  (Vr_Vs*Bto)^2/(sg * alpha_to * rho_to * Clm_to) *WL/g;
TW = [TW TW_to];

WL_ldg = 0.5*rho_ldg*Vs^2*Clm_ldg/9.81;
WL_limit = WL_ldg * 2.20462/10.7639;

% Constraint Analysis Map

TW_dp = 0.4; WL_dp = 51.5;

clf; hold on; f1 = figure(1);
plot(WL_lb, TW, LineWidth=2)
xline(WL_limit,LineWidth=2,LineStyle="-.")
plot(WL_dp, TW_dp,'Marker','square','MarkerFaceColor','y', ...
        'color','black','MarkerSize',9)
xlabel('Wing Loading, $\left(\frac{lb}{ft^2}\right)$','Interpreter','latex')
ylabel('Thrust Loading','Interpreter','latex')
legend('Cruise','Manuever','Ceiling','TOLDG')
text(52,0.37,1,'[51.5, 0.4]','EdgeColor','black','BackgroundColor','white','FontSize',15)

grid on; grid minor; hold off; 

%% Design Point Required Thrust
alt_ft = [38000 38000 10000 42000 0 0];
M = [0.63 0.63 0.7 0.8 0.2 0];

Wto = 64934;
TW_need = TW(WL_lb == WL_dp,:);
TW_need = [TW_need(1) 0.4 TW_need(2:end) 0.4];
thrustLapse = thrustLapseDatatable(alt_ft,M);

T_in = 1.05e-3 * Wto * TW_need .* thrustLapse;

% T_un = TW_need*Wto;
% 
% [~,TR,PR] = flowisentropic(gamma,0.63,'mach');
% P1 = Pt * (PR)^-1;
% T1 = Tt * (TR)^-1;
% V1 = 0.65*sqrt(gamma.*287.05.*T1);
% % D_add = W.*(V1 - V) + (P1 - P)*A;
% 
% % T_in = vpa(T_un*1.05e-3,4)
% T_peak = Wto*TW_dp*1.05e-3;
% T_in = [T_un(1)*1.05e-3 T_peak T_un(2:end)*1.05e-3]

%% Additive Drag