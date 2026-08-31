clc; clear; close all;

%% =========================
%  INPUT: YOUR GASTURB DATA
%  =========================
FN_kN          = 28.2057;      % Net thrust [kN]
BPR            = 2.18433;    % Bypass ratio [-]
mdot_total     = 59.9831;    % Total inlet mass flow [kg/s]
mdot_core      = 18.837;     % Core mass flow [kg/s] (optional check)

% Optional consistency check
mdot_total_check = mdot_core * (1 + BPR);

%% ======================================
%  ASSUMPTIONS FOR MASS FLOW DIAMETER SIZING
%  ======================================
rho_inlet       = 1.225;    % kg/m^3, sea-level static assumption
Vax             = 143.826;  % m/s, assumed fan-face axial velocity
hub_tip_ratio   = 0.40;     % lambda = Dh/Dt
spaceclaim_fac  = 1.20;     % overall packaging multiplier

%% ======================================
%  REFERENCE ENGINES FOR SCALING
%  ======================================
% GE F404
F404.name       = 'GE F404';
F404.diam_in    = 35.0;     % max diameter [in]
F404.length_in  = 154.0;    % length [in]
F404.weight_lb  = 2282.0;   % dry weight [lb]

% Honeywell / ITEC F124
F124.name       = 'Honeywell F124';
F124.diam_in    = 24.0;     % max diameter [in]
F124.length_in  = 112.0;    % length [in]
F124.weight_lb  = 1180.0;   % dry weight [lb]

refs = [F404, F124];

%% ======================================
%  UNIT CONVERSIONS
%  ======================================
IN_PER_M    = 39.3701;
LB_PER_KG   = 2.20462;
KG_PER_LB   = 1 / LB_PER_KG;

%% ======================================
%  1) DIAMETER FROM MASS FLOW
%  mdot = rho * V * A
%  A = pi/4 * Dt^2 * (1-lambda^2)
%  ======================================
lambda = hub_tip_ratio;

A_annulus = mdot_total / (rho_inlet * Vax);

fan_tip_diam_m = sqrt( (4 * A_annulus) / (pi * (1 - lambda^2)) );
fan_tip_diam_in = fan_tip_diam_m * IN_PER_M;

overall_diam_m = spaceclaim_fac * fan_tip_diam_m;
overall_diam_in = overall_diam_m * IN_PER_M;

%% ======================================
%  2) LENGTH SCALED FROM EXISTING ENGINES
%  Linear scale from diameter
%  ======================================
for i = 1:length(refs)
    refs(i).scaled_length_in = refs(i).length_in * (overall_diam_in / refs(i).diam_in);
    refs(i).scaled_length_m  = refs(i).scaled_length_in / IN_PER_M;
end

length_vals_in = [refs.scaled_length_in];
avg_length_in  = mean(length_vals_in);
avg_length_m   = avg_length_in / IN_PER_M;

%% ======================================
%  3) WEIGHT SCALED FROM EXISTING ENGINES
%  Use volume-style scaling: W ~ D^2 * L
%  ======================================
for i = 1:length(refs)
    refs(i).scaled_weight_lb = refs(i).weight_lb * ...
        (overall_diam_in / refs(i).diam_in)^2 * ...
        (avg_length_in / refs(i).length_in);

    refs(i).scaled_weight_kg = refs(i).scaled_weight_lb * KG_PER_LB;
end

weight_vals_lb = [refs.scaled_weight_lb];
avg_weight_lb  = mean(weight_vals_lb);
avg_weight_kg  = avg_weight_lb * KG_PER_LB;

%% ======================================
%  OPTIONAL: PURE CUBIC WEIGHT SCALING
%  W ~ scale^3
%  ======================================
for i = 1:length(refs)
    refs(i).scaled_weight_cubic_lb = refs(i).weight_lb * ...
        (overall_diam_in / refs(i).diam_in)^3;

    refs(i).scaled_weight_cubic_kg = refs(i).scaled_weight_cubic_lb * KG_PER_LB;
end

weight_cubic_vals_lb = [refs.scaled_weight_cubic_lb];
avg_weight_cubic_lb  = mean(weight_cubic_vals_lb);
avg_weight_cubic_kg  = avg_weight_cubic_lb * KG_PER_LB;

%% ======================================
%  PRINT RESULTS
%  ======================================
fprintf('\n============================================\n');
fprintf('      2-SPOOL TRAINER TURBOFAN SIZING\n');
fprintf('============================================\n');

fprintf('\nINPUT CYCLE DATA:\n');
fprintf('FN                 = %.2f kN\n', FN_kN);
fprintf('BPR                = %.4f\n', BPR);
fprintf('Total mass flow    = %.3f kg/s\n', mdot_total);
fprintf('Core mass flow     = %.3f kg/s\n', mdot_core);
fprintf('Check total flow   = %.3f kg/s\n', mdot_total_check);

fprintf('\nDIAMETER FROM MASS FLOW:\n');
fprintf('Fan tip diameter   = %.3f m  (%.2f in)\n', fan_tip_diam_m, fan_tip_diam_in);
fprintf('Overall space claim= %.3f m  (%.2f in)\n', overall_diam_m, overall_diam_in);

fprintf('\nLENGTH ESTIMATES:\n');
for i = 1:length(refs)
    fprintf('%-18s : %.2f in  (%.3f m)\n', refs(i).name, ...
        refs(i).scaled_length_in, refs(i).scaled_length_m);
end
fprintf('Average length     = %.2f in  (%.3f m)\n', avg_length_in, avg_length_m);

fprintf('\nWEIGHT ESTIMATES (D^2*L scaling):\n');
for i = 1:length(refs)
    fprintf('%-18s : %.1f lb  (%.1f kg)\n', refs(i).name, ...
        refs(i).scaled_weight_lb, refs(i).scaled_weight_kg);
end
fprintf('Average weight     = %.1f lb  (%.1f kg)\n', avg_weight_lb, avg_weight_kg);

fprintf('\nWEIGHT ESTIMATES (pure cubic scaling):\n');
for i = 1:length(refs)
    fprintf('%-18s : %.1f lb  (%.1f kg)\n', refs(i).name, ...
        refs(i).scaled_weight_cubic_lb, refs(i).scaled_weight_cubic_kg);
end
fprintf('Average cubic wt   = %.1f lb  (%.1f kg)\n', avg_weight_cubic_lb, avg_weight_cubic_kg);

fprintf('\n============================================\n');