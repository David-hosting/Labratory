%% Clear
clc;
clear;
close all;

%% Data

R = 4.697e3;
C = 9.802e-9;

f_CO = 3.386e3;

Amp = 2.5;

SCOPE_PHASE_ERROR = 1.8; % degrees

f = 1e3 .* [0.3 0.8 2 3 3.386 6 10 25 50];

VR = [0.32 0.72 1.29 1.69 1.77 2.09 2.25 2.33 2.41];
VC = [2.65 2.49 2.17 1.85 1.77 1.29 0.88 0.4 0.17];

PHIR = -1 .* [-83.65 -74.8 -57.9 -47.8 -45.2 -30.7 -20 -8.24 -4.82];
PHIC = -1 .* [5.28 13.3 33 41.8 44.6 64 71 83 88.08];

%% Experimental transfer functions

H_R = VR ./ Amp;
H_C = VC ./ Amp;

MAG_R = 20 * log10(abs(H_R));
MAG_C = 20 * log10(abs(H_C));

% 5 percent amplitude uncertainty converted to dB
ERR_DB = 20 * log10(1.05);

%% Theoretical curves

f_theory = logspace(log10(300),5,2000);

% High-pass across resistor
H_R_theory = 1 ./ (1 - 1j .* (f_CO ./ f_theory));

% Low-pass across capacitor
H_C_theory = 1 ./ (1 + 1j .* (f_theory ./ f_CO));

MAG_R_theory = 20 * log10(abs(H_R_theory));
MAG_C_theory = 20 * log10(abs(H_C_theory));

PHASE_R_theory = angle(H_R_theory) * 180/pi;
PHASE_C_theory = angle(H_C_theory) * 180/pi;

%% Plot

figure('Color','black','Position',[100 100 1200 800]);
tiledlayout(2,2,'TileSpacing','loose','Padding','loose');
%% =========================
% Magnitude H_R
% ==========================

nexttile;

errorbar(f, MAG_R, ...
         ERR_DB .* ones(size(f)), ...
         'o', ...
         'LineWidth',1.5, ...
         'MarkerSize',6);

hold on;

semilogx(f_theory, ...
         MAG_R_theory, ...
         '-', ...
         'LineWidth',2, 'Color', '#D4AF37');

grid on;
set(gca,'XScale','log');

title('|H_R(f)|');
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');

legend('Measured','Theory','Location','southwest');

xlim([300 1e5]);
ylim([-25 5]);

%% =========================
% Magnitude H_C
% ==========================

nexttile;

errorbar(f, MAG_C, ...
         ERR_DB .* ones(size(f)), ...
         'o', ...
         'LineWidth',1.5, ...
         'MarkerSize',6);

hold on;

semilogx(f_theory, ...
         MAG_C_theory, ...
         '-', ...
         'LineWidth',2, 'Color', '#D4AF37');

grid on;
set(gca,'XScale','log');

title('|H_C(f)|');
xlabel('Frequency [Hz]');
ylabel('Magnitude [dB]');

legend('Measured','Theory','Location','southwest');

xlim([300 1e5]);
ylim([-25 5]);

%% =========================
% Phase H_R
% ==========================

nexttile;

errorbar(f, PHIR, ...
         SCOPE_PHASE_ERROR .* ones(size(f)), ...
         'o', ...
         'LineWidth',1.5, ...
         'MarkerSize',6);

hold on;

semilogx(f_theory, ...
         PHASE_R_theory, ...
         '-', ...
         'LineWidth',2, 'Color', '#D4AF37');

grid on;
set(gca,'XScale','log');

title('\angle H_R(f)');
xlabel('Frequency [Hz]');
ylabel('Phase [deg]');

legend('Measured','Theory','Location','southwest');

xlim([300 1e5]);
ylim([0 100]);

%% =========================
% Phase H_C
% ==========================

nexttile;

errorbar(f, PHIC, ...
         SCOPE_PHASE_ERROR .* ones(size(f)), ...
         'o', ...
         'LineWidth',1.5, ...
         'MarkerSize',6);

hold on;

semilogx(f_theory, ...
         PHASE_C_theory, ...
         '-', ...
         'LineWidth',2, 'Color', '#D4AF37');

grid on;
set(gca,'XScale','log');

title('\angle H_C(f)');
xlabel('Frequency [Hz]');
ylabel('Phase [deg]');

legend('Measured','Theory','Location','southwest');

xlim([300 1e5]);
ylim([-100 0]);

%% Global title

sgtitle('Bode Plots of RC Filter');