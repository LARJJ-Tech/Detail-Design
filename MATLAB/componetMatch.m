clc; clear; close all;

data = dataImport("..\Data\GasTurb\comprehensiveMissionPerformanceData.xlsx");
%% HP c mf
HPCm_dot = data("HPC Pressure Ratio",[2:11, 13:end]);
disp(HPCm_dot)
HPCm_dot = data{"HPC Pressure Ratio",[2:11 13:end]};
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

HPCrpm = 21079.32;

HPTrpm = HPCrpm * (hptspeed/hpcspeed);
fprintf("HPC RPM: %f\n",HPCrpm)
fprintf("HPT RPM: %f\n\n",HPTrpm)
fprintf("==================================================================\n\n")


%% LP c mf
HPCm_dot = data("LPC Outer Pressure Ratio",[2:11 13:end]);
disp(HPCm_dot)
LPCm_dot = data{"LPC Outer Pressure Ratio",[2:11 13:end]};
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

LPCrpm = 10820.73;

LPTrpm = LPCrpm * (lptspeed/lpcspeed);
fprintf("LPC RPM: %f\n",LPCrpm)
fprintf("LPT RPM: %f\n\n",LPTrpm)
fprintf("==================================================================\n")


%% Scale to OD
dataOD = dataImport("..\Data\GasTurb\onDesignPerformance.xlsx");

%LPC
LPCeffRatio = dataOD{"Polytr. Outer LPC Efficiency",2}/data{"Polytr. Outer LPC Efficiency",condf};
LPCprRatio = (((data{"Fan Outer Exit Press P13",condf}/data{"Inlet Pressure P2",condf})-1)/((dataOD{"Fan Outer Exit Press P13",2}/dataOD{"Inlet Pressure P2",2})-1));
LPCrpmRatio = dataOD{"Nominal LP Spool Speed [RPM]",2}/data{"LP Spool Speed [RPM]",condf};
LPCTRatio = dataOD{"Fan Outer Exit Temp T13",2}/data{"Fan Outer Exit Temp T13",condf};
LPCPRatio = dataOD{"Fan Outer Exit Press P13",2}/data{"Fan Outer Exit Press P13",condf};

%HPC
HPCeffRatio = dataOD{"Polytropic HPC Efficiency",2}/data{"Polytropic HPC Efficiency",condc};
HPCprRatio = ((data{"HPC Exit Pressure P3",condc}/data{"HPC Inlet Pressure P25",condc})-1)/((dataOD{"HPC Exit Pressure P3",2}/dataOD{"HPC Inlet Pressure P25",2})-1);
HPCrpmRatio = dataOD{"Nominal HP Spool Speed [RPM]",2}/data{"HP Spool Speed [RPM]",condc};
HPCTRatio = dataOD{"HPC Exit Temperature T3",2}/data{"HPC Exit Temperature T3",condc};
HPCPRatio = dataOD{"HPC Exit Pressure P3",2}/data{"HPC Exit Pressure P3",condc};

%HPT
HPTeffRatio = dataOD{"Polytropic HPT Efficiency",2}/data{"Polytropic HPT Efficiency",condt};
HPTprRatio = ((data{"Burner Exit Pressure P4",condt}/data{"HPT Exit Pressure P44",condt})-1)/((dataOD{"Burner Exit Pressure P4",2}/dataOD{"HPT Exit Pressure P44",2})-1);
HPTrpmRatio = dataOD{"Nominal HP Spool Speed [RPM]",2}/data{"HP Spool Speed [RPM]",condt};
HPTTRatio = dataOD{"LPT Inlet Temperature T45",2}/data{"LPT Inlet Temperature T45",condt};
HPTPRatio = dataOD{"HPT Exit Pressure P44",2}/data{"HPT Exit Pressure P44",condt};

%LPT
LPTeffRatio = dataOD{"Polytropic LPT Efficiency",2}/data{"Polytropic LPT Efficiency",condlt};
LPTprRatio = ((data{"LPT Inlet Pressure P45",condlt}/data{"LPT Exit Pressure P5",condlt})-1)/((dataOD{"LPT Inlet Pressure P45",2}/dataOD{"LPT Exit Pressure P5",2})-1);
LPTrpmRatio = dataOD{"Nominal LP Spool Speed [RPM]",2}/data{"LP Spool Speed [RPM]",condlt};
LPTTRatio = dataOD{"LPT Exit Temperature T5",2}/data{"LPT Exit Temperature T5",condlt};
LPTPRatio = dataOD{"LPT Exit Pressure P5",2}/data{"LPT Exit Pressure P5",condlt};

fprintf("\nLPC  η  Ratio: %f\n",LPCeffRatio)
fprintf("LPC  PR  Ratio: %f\n",LPCprRatio)
fprintf("LPC RPM Ratio: %f\n",LPCrpmRatio)
fprintf("LPC T Ratio: %f\n",LPCTRatio)
fprintf("LPC P Ratio: %f\n\n",LPCPRatio)

fprintf("HPC  η  Ratio: %f\n",HPCeffRatio)
fprintf("HPC  PR  Ratio: %f\n",HPCprRatio)
fprintf("HPC RPM Ratio: %f\n",HPCrpmRatio)
fprintf("HPC T Ratio: %f\n",HPCTRatio)
fprintf("HPC P Ratio: %f\n\n",HPCPRatio)

fprintf("HPT  η  Ratio: %f\n",HPTeffRatio)
fprintf("HPT  PR  Ratio: %f\n",HPTprRatio)
fprintf("HPT RPM Ratio: %f\n",HPTrpmRatio)
fprintf("HPT T Ratio: %f\n",HPTTRatio)
fprintf("HPT P Ratio: %f\n\n",HPTPRatio)

fprintf("LPT  η  Ratio: %f\n",LPTeffRatio)
fprintf("LPT  PR  Ratio: %f\n",LPTprRatio)
fprintf("LPT RPM Ratio: %f\n",LPTrpmRatio)
fprintf("LPT T Ratio: %f\n",LPTTRatio)
fprintf("LPT P Ratio: %f\n\n",LPTPRatio)
fprintf("==================================================================\n")

%% OD Values
%LPC
LPCeff = 0.93*LPCeffRatio;
LPCpr = (2.09-1)/LPCprRatio+1;
LPCrpmd = 10820.73*LPCrpmRatio;
LPCt = 203.89*LPCTRatio;
LPCp = 62.57*LPCPRatio;

%HPC
HPCeff = 0.873*HPCeffRatio;
HPCpr = (9.06-1)/HPCprRatio+1;
HPCrpmd = 21079.32*HPCrpmRatio;
HPCt = 617.78*HPCTRatio;
HPCp = 690.73*HPCPRatio;

%HPT
HPTeff = 0.869*HPTeffRatio;
HPTpr = (3.32-1)/HPTprRatio+1;
HPTrpmd = 22203.79*HPTrpmRatio;
HPTt = 1132.57*HPTTRatio;
HPTp = 445.73*HPTPRatio;

%LPT
LPTeff = 0.902*LPTeffRatio;
LPTpr = (2.55-1)*LPTprRatio+1;
LPTrpmd = 11265.87*LPTrpmRatio;
LPTt = 918.77*LPTTRatio;
LPTp = 174.59*LPTPRatio;

fprintf("\nLPC  η : %f\n",LPCeff)
fprintf("LPC  PR  : %f\n",LPCpr)
fprintf("LPC  T  : %f\n",LPCt)
fprintf("LPC  P  : %f\n",LPCp)
fprintf("LPC RPM : %f\n\n",LPCrpmd)

fprintf("HPC  η  : %f\n",HPCeff)
fprintf("HPC  PR  : %f\n",HPCpr)
fprintf("HPC  T  : %f\n",HPCt)
fprintf("HPC  P  : %f\n",HPCp)
fprintf("HPC RPM : %f\n\n",HPCrpmd)

fprintf("HPT  η  : %f\n",HPTeff)
fprintf("HPT  PR  : %f\n",HPTpr)
fprintf("HPT  T  : %f\n",HPTt)
fprintf("HPT  P  : %f\n",HPTp)
fprintf("HPT RPM : %f\n\n",HPTrpmd)

fprintf("LPT  η  : %f\n",LPTeff)
fprintf("LPT  PR  : %f\n",LPTpr)
fprintf("LPT  T  : %f\n",LPTt)
fprintf("LPT  P  : %f\n",LPTp)
fprintf("LPT RPM : %f\n\n",LPTrpmd)
fprintf("==================================================================\n")