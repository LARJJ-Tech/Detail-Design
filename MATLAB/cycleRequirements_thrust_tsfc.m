clc;clear;close all


% AE 440 - JET PROP DETAIL DESIGN
% RUN DONG - LARJJ TECH
% Thrust and TSFC at different design points

%  x = [toldg toc cruise manuevers ceiling]
% variables form GASTURB - all SI Units

% ENGINE INLET MASS FLOW AND CORRECTED MASS FLOW

altitude = [];
[T_ref, P_ref] = atmosisa(altitude);
mdot0 = []; % kg/s
Ttin = [];
Ptin = [];
mcorr = mdot0*sqrt(Tt_in/Tref)./(Pt_in/Pref); % kg/s
mdotexit = []; % kg/s
Vexit = []; % m/s
Pexit = []; % Pa
P0 = []; % Pa
A = []; 

% THRUST

Fn = mdotexit*Vexit+(Pexit-P0)*A; % kN

% TSFC

TSFC = mdotexit/Fn; % (g/s)/N

% SPECIFIC THRUST

SF = Fn/mdot0;

% PRINTS

fprintf('Thrust (Fn): %.2f kN\n', Fn);
fprintf('TSFC: %.4f (g/s)/N\n', TSFC);
fprintf('SF: %.2f m/s',SF)



