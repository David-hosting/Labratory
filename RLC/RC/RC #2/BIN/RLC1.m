%% Run section
clc;
clearvars;
close all;

%% Input Volatage
input = readmatrix('DN - RC 1.1 vpp=5.csv');
input_time = input(:,2);
input_voltage = input(:,3);

input_time = input_time - min(input_time);
in_t_start = 0.0046; 
in_t_end   = 0.1546;

in_idx = (input_time >= in_t_start) & (input_time <= in_t_end);

in_time_cut = input_time(in_idx);
in_voltage_cut = input_voltage(in_idx);

in_time_cut = in_time_cut - min(in_time_cut);

input_error_bar = 0.05*abs(in_voltage_cut);

%% Data Section
datasheet = readmatrix('RC Capacitor Voltage DC DN.csv');

time = datasheet(:,2);
voltage = datasheet(:,3);

% Shift time so it starts at 0
time = time - min(time);

% Main cut range
t_start = 0.0402;
t_end   = 0.1902;

idx = (time >= t_start) & (time <= t_end);
time_cut = time(idx);
voltage_cut = voltage(idx);

% Shift cut time so it starts at 0
time_cut = time_cut - time_cut(1);

% Sub-ranges
idx1_c = (time_cut >= 0)      & (time_cut < 0.025);
idx1_d = (time_cut >= 0.025)  & (time_cut < 0.05);

idx2_c = (time_cut >= 0.05)   & (time_cut < 0.075);
idx2_d = (time_cut >= 0.075)  & (time_cut < 0.1);

idx3_c = (time_cut >= 0.1)    & (time_cut < 0.1249);
idx3_d = (time_cut >= 0.1249) & (time_cut <= 0.1499);

% Charge
time1_c    = time_cut(idx1_c);
voltage1_c = voltage_cut(idx1_c);

time2_c    = time_cut(idx2_c);
voltage2_c = voltage_cut(idx2_c);

time3_c    = time_cut(idx3_c);
voltage3_c = voltage_cut(idx3_c);

% Discharge
time1_d    = time_cut(idx1_d);
voltage1_d = voltage_cut(idx1_d);

time2_d    = time_cut(idx2_d);
voltage2_d = voltage_cut(idx2_d);

time3_d    = time_cut(idx3_d);
voltage3_d = voltage_cut(idx3_d);

% Reset local time for each segment
time1_c = time1_c - time1_c(1);
time2_c = time2_c - time2_c(1);
time3_c = time3_c - time3_c(1);

time1_d = time1_d - time1_d(1);
time2_d = time2_d - time2_d(1);
time3_d = time3_d - time3_d(1);

%% fit section
ft = fittype('Vf + (Vi - Vf)*exp(-x/tau)', ...
    'independent','x', ...
    'coefficients', {'Vi','Vf','tau'});


%% Plot 1 Charge
figure(1);
subplot(2,3,1)
dv_1c = 0.05*abs(voltage1_c);
errorbar(time1_c, voltage1_c, dv_1c, 'go');
grid on;
xlabel('Time [s]')
ylabel('Voltage [V]')
title('Part 1 Charge')

f1_c = fit(time1_c, voltage1_c, ft, ...
           'StartPoint', [voltage1_c(1), voltage1_c(end), 0.00266])

hold on
xfit = linspace(min(time1_c), max(time1_c), 200);
yfit = f1_c(xfit);
plot(xfit, yfit, 'r-', 'LineWidth', 2)
hold off
legend("Real Data Charge", "Curve Fit")

% Plot 1 Discharge
subplot(2,3,4)
dv_1d = 0.05*abs(voltage1_d);
errorbar(time1_d, voltage1_d, dv_1d, 'go');
grid on;
xlabel('Time [s]')
ylabel('Voltage [V]')
title('Part 1 Discharge')

f1_d = fit(time1_d, voltage1_d, ft, ...
           'StartPoint', [voltage1_d(1), voltage1_d(end), 0.00266])

hold on
xfit = linspace(min(time1_d), max(time1_d), 200);
yfit = f1_d(xfit);
plot(xfit, yfit, 'r-', 'LineWidth', 2)
hold off
legend("Real Data Charge", "Curve Fit")

% Plot 2 Charge
subplot(2,3,2)
dv_2c = 0.05*abs(voltage2_c);
errorbar(time2_c, voltage2_c, dv_2c, 'go');
grid on;
xlabel('Time [s]')
ylabel('Voltage [V]')
title('Part 2 Charge')

f2_c = fit(time2_c, voltage2_c, ft, ...
           'StartPoint', [voltage2_c(1), voltage2_c(end), 0.00266])

hold on
xfit = linspace(min(time2_c), max(time2_c), 200);
yfit = f2_c(xfit);
plot(xfit, yfit, 'r-', 'LineWidth', 2)
hold off
legend("Real Data Charge", "Curve Fit")

% Plot 2 Discharge
subplot(2,3,5)
dv_2d = 0.05*abs(voltage2_d);
errorbar(time2_d, voltage2_d, dv_2d, 'go');
grid on;
xlabel('Time [s]')
ylabel('Voltage [V]')
title('Part 2 Discharge')

f2_d = fit(time2_d, voltage2_d, ft, ...
           'StartPoint', [voltage2_d(1), voltage2_d(end), 0.00266])

hold on
xfit = linspace(min(time2_d), max(time2_d), 200);
yfit = f2_d(xfit);
plot(xfit, yfit, 'r-', 'LineWidth', 2)
hold off
legend("Real Data Charge", "Curve Fit")

%% Plot 3 Charge
subplot(2,3,3)
dv_3c = 0.05*abs(voltage3_c);
errorbar(time3_c, voltage3_c, dv_3c, 'go');
grid on;
xlabel('Time [s]')
ylabel('Voltage [V]')
title('Part 3 Charge')

f3_c = fit(time3_c, voltage3_c, ft, ...
           'StartPoint', [voltage3_c(1), voltage3_c(end), 0.00266])

hold on
xfit = linspace(min(time3_c), max(time3_c), 200);
yfit = f3_c(xfit);
plot(xfit, yfit, 'r-', 'LineWidth', 2)
hold off
legend("Real Data Charge", "Curve Fit")

% Plot 3 Discharge
subplot(2,3,6)
dv_3d = 0.05*abs(voltage3_d);
errorbar(time3_d, voltage3_d, dv_3d, 'go');
grid on;
xlabel('Time [s]')
ylabel('Voltage [V]')
title('Part 3 Discharge')

f3_d = fit(time3_d, voltage3_d, ft, ...
           'StartPoint', [voltage3_d(1), voltage3_d(end), 0.00266])

hold on
xfit = linspace(min(time3_d), max(time3_d), 200);
yfit = f3_d(xfit);
plot(xfit, yfit, 'r-', 'LineWidth', 2)

hold off
legend("Real Data Charge", "Curve Fit")
%% Figure2
figure(2);
hold on
errorbar(time1_c + 0,       voltage1_c, dv_1c, 'r*', 'MarkerSize', 10);
errorbar(time1_d + 0.025,   voltage1_d, dv_1d, 'b*', 'MarkerSize', 10);
errorbar(time2_c + 0.05,    voltage2_c, dv_2c, 'r*', 'MarkerSize', 10);
errorbar(time2_d + 0.075,   voltage2_d, dv_2d, 'b*', 'MarkerSize', 10);
errorbar(time3_c + 0.1,     voltage3_c, dv_3c, 'r*', 'MarkerSize', 10);
errorbar(time3_d + 0.1249,  voltage3_d, dv_3d, 'b*', 'MarkerSize', 10);
% plot(input_time, input_voltage)
errorbar(in_time_cut, in_voltage_cut, input_error_bar, 'Marker', '.', 'MarkerSize', 10)

grid on
xlabel('Time [s]')
ylabel('Voltage [V]')
title('All segments together')
legend('#1 Erorr-Bar Charge',  '#1 Erorr-Bar Discharge', ...
       '#2 Erorr-Bar Charge',  '#2 Erorr-Bar Discharge', ...
       '#3 Erorr-Bar Charge',  '#3 Erorr-Bar Discharge', ...
       'Input Volatage')



hold off