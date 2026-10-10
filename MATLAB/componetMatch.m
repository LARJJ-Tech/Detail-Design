clc; clear; close all;

data = dataImport("..\Data\GasTurb\comprehensiveMissionPerformanceData.xlsx");
%% HP c mf
HPCm_dot = data("HPC Inlet C Flow W25Rstd",[2:11, 13:end]);
disp(HPCm_dot)
HPCm_dot = data{"HPC Inlet C Flow W25Rstd",[2:11 13:end]};
[mfc, idxc] = max(HPCm_dot);
condc = data.Properties.VariableNames{idxc+1};
fprintf("Design HPC at: %s\n\n", condc)
fprintf("==================================================================\n\n")

HPTm_dot = data("HPT Power",[2:11 13:end]);
disp(HPTm_dot)
HPTm_dot = data{"HPT Power",[2:11 13:end]};
[mft, idxt] = max(HPTm_dot);
condt = data.Properties.VariableNames{idxt+1};
fprintf("Design HPT at: %s\n\n", condt)
fprintf("==================================================================\n\n")

%% HP cyc
cycc = data(["HPC Inlet Flow W25","HPC Inlet Pressure P25","Fan Inner Exit Temp T21","HPC Spec. Work"],condc);
disp(cycc)

cyct = data(["HPT Rotor Inlet Flow W41","Burner Exit Pressure P4","HPT Rotor Inlet Temp T41","HPT Spec. Work"],condt);
disp(cyct)
fprintf("==================================================================\n\n")

%% HP RPM Match
hpcspeed = data{"Rel. HP Spool Speed",condc};
hptspeed = data{"Rel. HP Spool Speed",condt};

HPCrpm = 21842.86;

HPTrpm = HPCrpm * (hptspeed/hpcspeed);
fprintf("HPC RPM: %f\n",HPCrpm)
fprintf("HPT RPM: %f\n\n",HPTrpm)
fprintf("==================================================================\n\n")


%% LP c mf
HPCm_dot = data("Total Inlet C Flow W2Rstd",[2:11 13:end]);
disp(HPCm_dot)
LPCm_dot = data{"Total Inlet C Flow W2Rstd",[2:11 13:end]};
[mff, idxf] = max(LPCm_dot);
condf = data.Properties.VariableNames{idxf+1};
fprintf("Design LPC at: %s\n\n", condf)
fprintf("==================================================================\n\n")

LPTm_dot = data("LPT Inlet C Flow W45Rstd",[2:11 13:end]);
disp(LPTm_dot)
LPTm_dot = data{"LPT Inlet C Flow W45Rstd",[2:11 13:end]};
[mflt, idxlt] = max(LPTm_dot);
condlt = data.Properties.VariableNames{idxlt+1};
fprintf("Design LPT at: %s\n\n", condlt)
fprintf("==================================================================\n\n")

%% LP cyc
cycf = data(["Total Mass Flow W2","Inlet Pressure P2","Inlet Temperature T2","Outer LPC Spec. Work"],condf);
disp(cycf)

cyclt = data(["LPT Inlet Flow W45","LPT Inlet Pressure P45","LPT Inlet Temperature T45","LPT Spec. Work"],condlt);
disp(cyclt)
fprintf("==================================================================\n\n")

%% LP RPM Match
lpcspeed = data{"Rel. LP Spool Speed",condf};
lptspeed = data{"Rel. LP Spool Speed",condlt};

LPCrpm = 10494.41;

LPTrpm = LPCrpm * (lptspeed/lpcspeed);
fprintf("LPC RPM: %f\n",LPCrpm)
fprintf("LPT RPM: %f\n\n",LPTrpm)
fprintf("==================================================================\n")