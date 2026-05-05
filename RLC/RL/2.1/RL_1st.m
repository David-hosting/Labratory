%% ================= CLEAN START =================
clc;
clear;
clearvars;

%% ================= LOAD DATA =================
RL_DATA = readmatrix('RL 2.1 with 20kHz.csv');
IN_DATA = readmatrix('Vpp 2.1 20kHZ.csv');

VL_time = RL_DATA(:,2);
VL      = RL_DATA(:,3);
IN_time = IN_DATA(:,2);
Vpp     = IN_DATA(:,3);

%% ================= TIME NORMALIZATION =================
VL_time = VL_time - min(VL_time);
IN_time = IN_time - min(IN_time);

%% ================= ERROR MODEL =================
VL_ERR  = 0.05 * abs(VL);
Vpp_ERR = 0.05 * abs(Vpp);

%% ================= SEGMENTS & PREPARATION =================
Nsegments = 6;
Ttotal = 0.000150502;
Tseg = Ttotal / Nsegments;

% מערך לאיסוף ערכי ה-Tau
taus = zeros(Nsegments, 1);

%% ================= FIT MODEL (NO +C) =================
% המודל המעודכן ללא קבוע C
ft = fittype('A*exp(-t/tau)', ...
    'independent','t', ...
    'coefficients',{'A','tau'});

%% ================= MAIN PROCESSING LOOP =================
max_V = max(VL);
min_V = min(VL);
y_margin = 0.5;

% הכנת פיגורות
figure(1); clf;
figure(2); clf;

for k = 1:Nsegments
    % הגדרת זמנים לסגמנט
    t1 = (k-1)*Tseg;
    t2 = t1 + Tseg;
    
    % חיתוך נתונים (VL)
    idxVL = (VL_time >= t1) & (VL_time <= t2);
    tVL   = VL_time(idxVL);
    vVL   = VL(idxVL);
    tVL_local = tVL - t1;
    
    % חיתוך נתונים (Vpp)
    idxIN = (IN_time >= t1) & (IN_time <= t2);
    tIN   = IN_time(idxIN);
    vIN   = Vpp(idxIN);
    tIN_local = tIN - t1;

    % --- ביצוע הפיט ---
    opts = fitoptions(ft);
    % חסמים מעודכנים עבור A ו-tau בלבד
    opts.Lower = [-3*(max(vVL)-min(vVL)), 1e-12];
    opts.Upper = [ 3*(max(vVL)-min(vVL)), Tseg];
    opts.Robust = 'Bisquare';
    % אתחול עבור A ו-tau בלבד
    opts.StartPoint = [vVL(1), Tseg/10];
    
    fit_success = false;
    if length(vVL) > 2 % הגנה למקרה של סגמנט ריק
        try
            fit_seg = fit(tVL_local, vVL, ft, opts)
            taus(k) = fit_seg.tau;
            
            t_fit_plot = linspace(min(tVL_local), max(tVL_local), 150);
            v_fit_plot = feval(fit_seg, t_fit_plot);
            
            % חיתוך ויזואלי של חריגות
            v_fit_plot(v_fit_plot > max_V + y_margin) = NaN;
            v_fit_plot(v_fit_plot < min_V - y_margin) = NaN;
            fit_success = true;
        catch
            taus(k) = NaN;
        end
    end

    % --- FIGURE 1 (Segmented View) ---
    figure(1);
    subplot(2,3,k); hold on;
    h1 = errorbar(tVL_local, vVL, VL_ERR(idxVL), 'LineStyle','none', 'Marker','o', 'Color', [0 0.6 0], 'CapSize', 4);
    h2 = errorbar(tIN_local, vIN, Vpp_ERR(idxIN), 'LineStyle','none', 'Marker','.', 'Color', 'b', 'CapSize', 4);
    if fit_success
        h3 = plot(t_fit_plot, v_fit_plot, 'r-', 'LineWidth', 2);
        legend([h1, h2, h3], {'V_L', 'V_{pp}', 'Fit'}, 'FontSize', 7, 'Location', 'best');
    else
        legend([h1, h2], {'V_L', 'V_{pp}'}, 'FontSize', 7, 'Location', 'best');
    end
    title(['Segment ', num2str(k)]); grid on;
    ylim([min_V - y_margin, max_V + y_margin]);

    % --- FIGURE 2 (Global View) ---
    figure(2); hold on;
    errorbar(tVL, vVL, VL_ERR(idxVL), 'LineStyle','none', 'Marker','o', 'Color', [0 0.5 0]);
    errorbar(tIN, vIN, Vpp_ERR(idxIN), 'LineStyle','none', 'Marker','.', 'Color', 'b');
    if fit_success
        plot(t_fit_plot + t1, v_fit_plot, 'r-', 'LineWidth', 2);
    end
end

% עיצוב סופי
figure(1); sgtitle('Segmented View: VL, Vpp & Local Fits (No Offset)');
figure(2);
ylim([min_V - y_margin, max_V + y_margin]);
grid on; xlabel('Time [s]'); ylabel('Voltage [V]');
legend('V_L Data', 'V_{pp} Data', 'Exp Fit', 'Location', 'northeastoutside');
title('Global View: Exponential Decay without Offset');

%% ================= STATISTICAL ANALYSIS =================
valid_taus = taus(~isnan(taus));

% תוצאות ל-LOG (ללא נקודה פסיק)
Mean_Tau = mean(valid_taus)
Std_Tau = std(valid_taus)
N_valid = length(valid_taus);
Statistical_Error = Std_Tau / sqrt(N_valid)
All_Taus_Collected = taus