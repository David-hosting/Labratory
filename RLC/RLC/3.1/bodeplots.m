%% =========================
% Clean RLC Bode Plot
%% =========================

clc;
clearvars;
close all force;

%% Data

L = 4.345e-3;
R = 1.0331e3;
C = 9.905e-9;

Amp = 2.5;
SCOPE_PHASE_ERROR = 3; % deg

f = 1e3 .* [1 3 6 10 11.85 15 20 24.26 24.86 30 40 49.69 80 120 180 250];

V_R = [0.185 0.48 0.96 1.53 1.69 2.01 2.25 2.33 2.33 2.25 2.01 ...
       1.77 1.21 0.88 0.64 0.48];

PHIR = -1*[-86.5 -76 -67.1 -52 -44 -32 -15.8 -1.2 0 13 31.7 43 60 71 77 88];

%% Experimental

H_R = V_R ./ Amp;
MAG_R = 20*log10(H_R);
ERR_DB = 20*log10(1.05);

%% Theory

f_theory = logspace(log10(2250),log10(270000),2000);
w = 2*pi*f_theory;

H_R_th = 1 ./ (1 + 1j*(w*L/R - 1./(w*R*C)));

MAG_R_th = 20*log10(abs(H_R_th));
PH_R_th  = angle(H_R_th)*180/pi;

%% Figure (SAFE RESET)

figure('Color','black','Position',[100 100 1200 500]);
tiledlayout(1,2,'TileSpacing','loose','Padding','loose');

%% =========================
% Magnitude
%% =========================

nexttile;
set(gca,'XScale','log');
hold on;

errorbar(f, MAG_R, ERR_DB*ones(size(f)), ...
    'o','LineWidth',1.5,'MarkerSize',6);

semilogx(f_theory, MAG_R_th, ...
    '-','LineWidth',2,'Color','#D4AF37');

grid on;
title('|H_R(f)|');
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
legend('Measured','Theory','Location','southwest');

xlim([100 1e6]);
ylim([-25 5]);

%% =========================
% Phase
%% =========================

nexttile;
set(gca,'XScale','log');
hold on;

errorbar(f, PHIR, SCOPE_PHASE_ERROR*ones(size(f)), ...
    'o','LineWidth',1.5,'MarkerSize',6);

semilogx(f_theory, PH_R_th, ...
    '-','LineWidth',2,'Color','#D4AF37');

grid on;
title('\angle H_R(f)');
xlabel('Frequency [Hz]');
ylabel('Phase [deg]');
legend('Measured','Theory','Location','southwest');

xlim([100 1e6]);
ylim([-100 100]);

%% Title
sgtitle('RLC Bode Plot');