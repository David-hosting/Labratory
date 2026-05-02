
Freqs      = 1000*[0.3,    0.8,    2,      3,      3.386,  10,     25,     100];
VR_mean         = [0.2372, 0.5930, 1.2412, 1.5704, 1.6583, 2.1910, 2.3035, 2.3357];
VC_mean         = [2.5327, 2.4422, 2.1055, 1.8090, 1.7045, 0.7839, 0.3457, 0.1085];
Stat_Err_R      = [0.004,  0.0041, 0.005,  0.0025, 0.0032, 0.0064, 0.0049, 0.004] ; 
Stat_Err_C      = [0,      0.0058, 0.005,  0,      0.004,  0,      0.004,  0.008]  ;

Err_Bar_R = max(Stat_Err_R, 0.05*ones(size(Stat_Err_R)));
Err_Bar_C = max(Stat_Err_C, 0.05*ones(size(Stat_Err_C)));

V_in = 2.5;

% ===== Figure 1 : Linear scale + fit =====
figure(1);

errorbar(Freqs, VR_mean/2.5, Err_Bar_R, '-o', 'DisplayName', 'VR Mean');
hold on;
errorbar(Freqs, VC_mean/2.5, Err_Bar_C, '-x', 'DisplayName', 'VC Mean');

% RC transfer functions
% Resistor output (High-pass): |H_R| = wRC / sqrt(1+(wRC)^2)
% Capacitor output (Low-pass): |H_C| = 1 / sqrt(1+(wRC)^2)

ft_R = fittype(@(fc,x) (x./fc)./sqrt(1 + (x./fc).^2), ...
    'independent','x','coefficients',{'fc'});

ft_C = fittype(@(fc,x) 1./sqrt(1 + (x./fc).^2), ...
    'independent','x','coefficients',{'fc'});

fit_R = fit(Freqs(:), (VR_mean(:)/V_in), ft_R, 'StartPoint', mean(Freqs))
fit_C = fit(Freqs(:), (VC_mean(:)/V_in), ft_C, 'StartPoint', mean(Freqs))

f_plot = logspace(log10(min(Freqs)), log10(max(Freqs)), 300);

plot(f_plot, fit_R(f_plot), 'b-', 'LineWidth',2, 'DisplayName','RC Fit R');
plot(f_plot, fit_C(f_plot), 'r-', 'LineWidth',2, 'DisplayName','RC Fit C');

xlabel('Frequency (Hz)');
ylabel('Normalized Amplitude');
title('Mean Values vs Frequency');
legend show;
grid on;



% ===== Figure 2 : Log scale + fit =====
figure(2);

errorbar(Freqs, VR_mean/V_in, Err_Bar_R, '-o', 'DisplayName', 'VR Mean');
hold on;

errorbar(Freqs, VC_mean/V_in, Err_Bar_C, '-x', 'DisplayName', 'VC Mean');

semilogx(f_plot, fit_R(f_plot), 'b-', 'LineWidth',2, 'DisplayName','RC Fit R');
semilogx(f_plot, fit_C(f_plot), 'r-', 'LineWidth',2, 'DisplayName','RC Fit C');

set(gca,'XScale','log');

xlabel('Frequency (Hz)');
ylabel('|H(f)|');
title('RC Transfer Function Fit');
legend show;
grid on;



% cutoff frequency result
fc_R = fit_R.fc
fc_C = fit_C.fc


