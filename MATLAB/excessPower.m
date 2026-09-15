%% Specific Excess Power Map
%  Ps = V * [ (alpha_T/B)*TW - k1*n^2*(B/q)*WL - k2*n - (Cd0+Cdr)/((B/q)*WL) ]
%
%  alpha_T  : thrust lapse (normalised total pressure ratio, P_t / P_t_sl)
%  B        : throttle ratio (0-1)
%  TW       : thrust-to-weight ratio at sea level, static, full throttle
%  WL       : wing loading [N/m^2]
%  k1,k2    : induced drag coefficients
%  Cd0      : zero-lift drag coefficient (Mach-dependent)
%  Cdr      : additional drag delta

% Inputs
TW  = 0.4;
WL  = 51.5* 47.8803;      % [N/m^2]  (42.5 lb/ft^2 converted)

k1  = 0.18;
k2  = 0;
Cdr = 0;
B   = 0.78;

gamma = 1.4;
n     = 1;                  % load factor

% Flight Envelope
M      = (0.01 : 0.001 : 1).';
alt_ft = 0 : 100 : 60000;
alt_m  = alt_ft * 0.3048;

% Atmosphere
[~, a, P, rho] = atmosisa(alt_m);
a   = a(:).';
P   = P(:).';
rho = rho(:).';

% Drag Polar
Cd0           = 0.014 * ones(size(M));
comp         = M > 0.8;
Cd0(comp)    = 0.014+(M(comp) -0.8)*0.035;
% Cd0(comp)    = 0.014 ./ sqrt(1 - M(comp).^2);

% Flight Conditions
V  = M  .* a;
q  = 0.5 .* rho .* V.^2;
Pt_ps   = (1 + (gamma-1)/2 .* M.^2) .^ (gamma/(gamma-1));
alpha_T = Fig_alpha(alt_ft,M);
% alpha_T = (P ./ 101325) .* Pt_ps;

% Specific Excess Power
Ps = V .* ( ...
    (alpha_T ./ B) .* TW          ...   % available thrust term
    - k1 .* n^2 .* (B ./ q) .* WL ...   % induced drag term
    - k2 .* n                     ...   % linear drag term
    - (Cd0 + Cdr) ./ ((B ./ q) .* WL)); % parasite drag term

% Power Map
hold on; f2 = figure(2);
[C, ~] = contour(M, alt_ft, Ps.', [0 0],'LineWidth', 2);

% plot(1,1,'black',LineStyle='--',LineWidth=2); 
% plot(1,1,'black', LineStyle='-.',LineWidth=2); 
% plot(1,1,'black', LineStyle=':',LineWidth=2);
% Ps_m = [10 25 50]*1/3.28;
% [~, ~] = contour(M, alt_ft, Ps.', [0 Ps_m(1)] , 'black','LineWidth', 2,'LineStyle','--');
% [~, ~] = contour(M, alt_ft, Ps.', [0 Ps_m(2)] , 'black','LineWidth', 2,'LineStyle','-.');
% [~, ~] = contour(M, alt_ft, Ps.', [0 Ps_m(3)] , 'black','LineWidth', 2,'LineStyle',':');
% pairs0 = extract_contour(C, 0);
% pairs = sortrows(pairs0, 2);

% close all;
grid on; grid minor;
% text(0.71,max(pairs(:,2)*1.02),'$P_s = 0$','Interpreter','latex')
xlabel('Flight Mach Number'); ylabel('Altitude [ft]');
% legend('P_s = 0 ft/s','P_s = 10 ft/s','P_s = 25 ft/s','P_s = 50 ft/s') 

% yline([5000:5000:35000 38000],'r')

%% Fucntions

function pairs = extract_contour(C, level)
%EXTRACT_CONTOUR  Parse MATLAB contour matrix for a given level.
    pairs = [];
    k = 1;
    while k < size(C, 2)
        lv   = C(1, k);
        npts = C(2, k);
        xy   = C(:, k+1 : k+npts);
        if abs(lv - level) < 1e-12
            pairs = [pairs; xy.'];
        end
        k = k + npts + 1;
    end
end

%% Find Max Speed at Altitude

alt = [10000:5000:35000 36000]';
c = C';
[row,~] = find(c == alt);
M_achieve = sort(c(row,1),1,"ascend")

legend('Takeoff: \beta = 1','Climb: \beta = 0.975', 'Cruise: \beta = 0.90','Descend: \beta = 0.85','Manuever: \beta = 0.80','Landing: \beta = 0.78','interpreter','latex')