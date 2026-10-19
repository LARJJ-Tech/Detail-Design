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
% idxf = 9;
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

LPCrpm = 9943.19;

LPTrpm = LPCrpm * (lptspeed/lpcspeed);
fprintf("LPC RPM: %f\n",LPCrpm)
fprintf("LPT RPM: %f\n\n",LPTrpm)
fprintf("==================================================================\n")


%% Scale to OD
dataOD = dataImport("..\Data\GasTurb\onDesignPerformance.xlsx");

%LPC
LPCeffRatio = dataOD{"Polytr. Outer LPC Efficiency",2}/data{"Polytr. Outer LPC Efficiency",condf};
LPCprRatio = (dataOD{"Fan Outer Exit Press P13",2}/dataOD{"Inlet Pressure P2",2})/(data{"Fan Outer Exit Press P13",condf}/data{"Inlet Pressure P2",condf});
LPCrpmRatio = dataOD{"Nominal LP Spool Speed [RPM]",2}/data{"LP Spool Speed [RPM]",condf};

%HPC
HPCeffRatio = dataOD{"Polytropic HPC Efficiency",2}/data{"Polytropic HPC Efficiency",condc};
HPCprRatio = (dataOD{"HPC Exit Pressure P3",2}/dataOD{"HPC Inlet Pressure P25",2})/(data{"HPC Exit Pressure P3",condc}/data{"HPC Inlet Pressure P25",condc});
HPCrpmRatio = dataOD{"Nominal HP Spool Speed [RPM]",2}/data{"HP Spool Speed [RPM]",condc};

%HPT
HPTeffRatio = dataOD{"Polytropic HPT Efficiency",2}/data{"Polytropic HPT Efficiency",condt};
HPTprRatio = (dataOD{"Burner Exit Pressure P4",2}/dataOD{"HPT Exit Pressure P44",2})/(data{"Burner Exit Pressure P4",condt}/data{"HPT Exit Pressure P44",condt});
HPTrpmRatio = dataOD{"Nominal HP Spool Speed [RPM]",2}/data{"HP Spool Speed [RPM]",condt};

%LPT
LPTeffRatio = dataOD{"Polytropic LPT Efficiency",2}/data{"Polytropic LPT Efficiency",condlt};
LPTprRatio = (dataOD{"LPT Inlet Pressure P45",2}/dataOD{"LPT Exit Pressure P5",2})/(data{"LPT Inlet Pressure P45",condlt}/data{"LPT Exit Pressure P5",condlt});
LPTrpmRatio = dataOD{"Nominal LP Spool Speed [RPM]",2}/data{"LP Spool Speed [RPM]",condlt};

fprintf("\nLPC  η  Ratio: %f\n",LPCeffRatio)
fprintf("LPC  P  Ratio: %f\n",LPCprRatio)
fprintf("LPC RPM Ratio: %f\n\n",LPCrpmRatio)

fprintf("HPC  η  Ratio: %f\n",HPCeffRatio)
fprintf("HPC  P  Ratio: %f\n",HPCprRatio)
fprintf("HPC RPM Ratio: %f\n\n",HPCrpmRatio)

fprintf("HPT  η  Ratio: %f\n",HPTeffRatio)
fprintf("HPT  P  Ratio: %f\n",HPTprRatio)
fprintf("HPT RPM Ratio: %f\n\n",HPTrpmRatio)

fprintf("LPT  η  Ratio: %f\n",LPTeffRatio)
fprintf("LPT  P  Ratio: %f\n",LPTprRatio)
fprintf("LPT RPM Ratio: %f\n\n",LPTrpmRatio)
fprintf("==================================================================\n")

%% OD Values
%LPC
LPCeff = 0.932*LPCeffRatio;
LPCpr = 2.06*LPCprRatio;
LPCrpmd = 9943.19*LPCrpmRatio;

%HPC
HPCeff = 0.872*HPCeffRatio;
HPCpr = 8.99*HPCprRatio;
HPCrpmd = 21842.86*HPCrpmRatio;

%HPT
HPTeff = 0.898*HPTeffRatio;
HPTpr = 2.96*HPTprRatio;
HPTrpmd = 22831.1*HPTrpmRatio;

%LPT
LPTeff = 0.932*LPTeffRatio;
LPTpr = 2.36*LPTprRatio;
LPTrpmd = 10172.57*LPTrpmRatio;

fprintf("\nLPC  η : %f\n",LPCeff)
fprintf("LPC  P  : %f\n",LPCpr)
fprintf("LPC RPM : %f\n\n",LPCrpmd)

fprintf("HPC  η  : %f\n",HPCeff)
fprintf("HPC  P  : %f\n",HPCpr)
fprintf("HPC RPM : %f\n\n",HPCrpmd)

fprintf("HPT  η  : %f\n",HPTeff)
fprintf("HPT  P  : %f\n",HPTpr)
fprintf("HPT RPM : %f\n\n",HPTrpmd)

fprintf("LPT  η  : %f\n",LPTeff)
fprintf("LPT  P  : %f\n",LPTpr)
fprintf("LPT RPM : %f\n\n",LPTrpmd)
fprintf("==================================================================\n")