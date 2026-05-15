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

f = 1e3 .* [1 3 6 10 15 17.7 20 24.26 24.7 28 33.25 50 80 120];

V_R =   [2.49 2.33 2.33 2.25 2.01 1.77 1.37 0.24 0.16 0.88 1.61 2.17 2.33 2.33];

PHIR = -1*[2.5 5.2 10.8 17 30.1 41.3 52 46.3 0 -63 -45.1 -22.7 -12 -9];

%% Experimental

H_R = V_R ./ Amp;
MAG_R = 20*log10(H_R);
ERR_DB = 20*log10(1.05);

%% Theory

f_theory = logspace(log10(1000),log10(270000),2000);
w = 2*pi*f_theory;

Z_LC = (1j*w*L).*(1./(1j*w*C)) ./ ((1j*w*L) + 1./(1j*w*C));

H_th = R ./ (R + Z_LC);   % voltage on R

MAG_R_th = 20*log10(abs(H_th));
PH_R_th  = angle(H_th)*180/pi;


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