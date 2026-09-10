clc;clear;close all

%% Input
data = dataImport(1);
cond = 2:7;
%% Calc
[Tamb,a,Pamb] = atmosisa(data{"Altitude",cond});
nfac = [1 1 1 1 1 1 1 100];

function FP=FP(data, cond)
FP = (data{"Inner LPC Spec. Work",cond}.*data{"Core Inlet Flow W21",cond})+(data{"Outer LPC Spec. Work",cond}.*data{"Bypass Inlet Flow W12",cond}); % FP = (Inner LPC Specific Work × Core Inlet Flow W21) + (Outer LPC Specific Work × Bypass Inlet Flow W12)
end
function CP=CP(data, cond)
CP = data{"HPC Spec. Work",cond}.*data{"HPC Exit Flow W3",cond}; % CP = HPC Specific Work × HPC Exit Flow W3
end
function FAR=FAR(data, cond)
FAR = data{"Total Fuel Flow",cond}./data{"HPC Exit Flow W3",cond}; % FAR = Total Fuel Flow / HPC Exit Flow W3
end

%% Tables

%Engine Cycle Perf
t1 = [Pamb(cond-1)/1000;Tamb(cond-1);data{["Mach Number" "HPT Stator Outlet Temp T405" "Overall Pressure Ratio P3/P2" "LPC Inner Pressure Ratio" "Bypass Ratio" "Net Thrust"],cond}; ...
    data{"Net Thrust",cond}.*224.8089431; data{"Specific Thrust",cond}; data{"Specific Thrust",cond}.*196.85; data{"Sp. Fuel Consumption",cond};...
    data{"Sp. Fuel Consumption",cond}.*3600./(453.592.*224.8089431); FAR(data,cond)].';

%LPC
t2 = [data{["Inlet Pressure P2", "Inlet Temperature T2", "Total Mass Flow W2", "Total Inlet C Flow W2Rstd", "LPC Inner Pressure Ratio"],cond};...
    FP(data,cond); data{["Polytr. Inner LPC Efficiency", "Rel. LP Spool Speed"],cond}].'.*nfac;

%HPC
t3 = [data{["HPC Inlet Pressure P25", "Fan Inner Exit Temp T21", "HPC Inlet Flow W25", "HPC Inlet C Flow W25Rstd", "HPC Pressure Ratio"],cond}; CP(data,cond); data{["Polytropic HPC Efficiency", "Rel. HP Spool Speed"],cond}].'.*nfac;

%HPT
t4 = data{["Burner Exit Pressure P4", "HPT Rotor Inlet Temp T41", "HPT Rotor Inlet Flow W41", "HPT Inlet C Flow W41Rstd", "HPT Pressure Ratio", "HPT Power", "Polytropic HPT Efficiency", "Rel. HP Spool Speed"],cond}.'.*nfac;

%LPT
t5 = data{["LPT Inlet Pressure P45", "LPT Inlet Temperature T45", "LPT Inlet Flow W45", "LPT Inlet C Flow W45Rstd", "LPT Pressure Ratio", "LPT Power", "Polytropic LPT Efficiency", "Rel. LP Spool Speed"],cond}.'.*nfac;