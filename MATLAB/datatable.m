clc;clear;close all

%% Input
data = readmatrix("off Design/Data5.xlsx",'Range','C1:R176');
cond = [6 5 11 1];

%% Calc
nfac = [1 1 1 1 1 1 1 100];
FP = (data(96,:).*data(72,:))+(data(95,:).*data(74,:));
CP = data(97,:).*data(78,:);
FAR = data(18,:)./data(78,:);

%% Tables

%Engine Cycle Perf
t1 = [data([7 53 19 141 147 10],cond);data(10,cond).*224.8089431; data(13,cond); data(13,cond).*196.85; data(12,cond); data(12,cond).*3600./(453.592.*224.8089431); FAR(1,cond)].';

%LPC
t2 = [data([39 38 70 71 141],cond); FP(1,cond); data([23 139],cond)].'.*nfac;

%HPC
t3 = [data([46 41 76 77 137],cond); CP(1,cond); data([27 133],cond)].'.*nfac;

%HPT
t4 = data([51 54 81 82 20 99 30 133],cond).'.*nfac;

%LPT
t5 =data([56 57 83 84 21 101 33 139],cond).'.*nfac;

