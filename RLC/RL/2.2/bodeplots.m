%% =========================
% RL Bode Plot - Clean Version
%% =========================

clc;
clear;
close all;

%% Parameters

f_CO = 5.25e3;
Amp = 2.5;

SCOPE_PHASE_ERROR = 3; % deg

%% Frequency data

f = 1e3 .* [0.5 1 2 4 5.25 6 10 20 50];

VR = [2.2 2.2 2.2 2.0 1.69 1.8 1.4 1.0 0.306];
VL = [0.273 0.041 0.683 1.17 1.41 1.53 1.93 2.25 2.37];

%% Phase measurements (fixed)

PHIR = -[7.1 12.6 21.2 33 39.1 44 58 74 81.9];
PHIL = -[-38.7 -52.1 -58.9 -48 -44 -27.4 -15 -7 -3];

%% Experimental transfer functions

H_R = VR ./ Amp;
H_L = VL ./ Amp;

MAG_R = 20*log10(H_R);
MAG_L = 20*log10(H_L);

ERR_DB = 20*log10(1.05);

%% Theory

f_theory = logspace(log10(300),5,2000);

H_R_th = 1 ./ (1 + 1j*(f_theory./f_CO));
H_L_th = 1 ./ (1 - 1j*(f_CO./f_theory));

MAG_R_th = 20*log10(abs(H_R_th));
MAG_L_th = 20*log10(abs(H_L_th));

PH_R_th = angle(H_R_th)*180/pi;
PH_L_th = angle(H_L_th)*180/pi;

%% Figure

figure('Color','black','Position',[100 100 1200 800]);
tiledlayout(2,2,'TileSpacing','loose','Padding','loose');

%% =========================
% Magnitude R
%% =========================

nexttile;
set(gca,'XScale','log');
hold on;

errorbar(f, MAG_R, ERR_DB*ones(size(f)), 'o','LineWidth',1.5);

plot(f_theory, MAG_R_th, 'LineWidth',2,'Color','#D4AF37');

grid on;
title('|H_R(f)|');
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
legend('Measured','Theory','Location','southwest');

xlim([300 1e5]);
ylim([-25 5]);

%% =========================
% Magnitude L
%% =========================

nexttile;
set(gca,'XScale','log');
hold on;

errorbar(f, MAG_L, ERR_DB*ones(size(f)), 'o','LineWidth',1.5);

plot(f_theory, MAG_L_th, 'LineWidth',2,'Color','#D4AF37');

grid on;
title('|H_L(f)|');
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');
legend('Measured','Theory','Location','southwest');

xlim([300 1e5]);
ylim([-25 5]);

%% =========================
% Phase R
%% =========================

nexttile;
set(gca,'XScale','log');
hold on;

errorbar(f, PHIR, SCOPE_PHASE_ERROR*ones(size(f)), ...
    'o','LineWidth',1.5,'MarkerSize',6);

plot(f_theory, PH_R_th, 'LineWidth',2,'Color','#D4AF37');

grid on;
title('\angle H_R(f)');
xlabel('Frequency [Hz]');
ylabel('Phase [deg]');
legend('Measured','Theory','Location','southwest');

xlim([300 1e5]);
ylim([-100 10]);

%% =========================
% Phase L
%% =========================

nexttile;
set(gca,'XScale','log');
hold on;

errorbar(f, PHIL, SCOPE_PHASE_ERROR*ones(size(f)), ...
    'o','LineWidth',1.5,'MarkerSize',6);

plot(f_theory, PH_L_th, 'LineWidth',2,'Color','#D4AF37');

grid on;
title('\angle H_L(f)');
xlabel('Frequency [Hz]');
ylabel('Phase [deg]');
legend('Measured','Theory','Location','southwest');

xlim([300 1e5]);
ylim([-10 100]);

%% Title

sgtitle('Bode Plot of RL Circuit');