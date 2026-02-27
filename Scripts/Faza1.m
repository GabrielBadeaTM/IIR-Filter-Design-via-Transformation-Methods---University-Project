%% Faza 1 a)
disp(' ');
disp('Faza 1 a):');

[b,a,M,W_c] = But_FTI_detailed(omega_p/pi, omega_s/pi, Delta_p, Delta_s, Ts); 
[H, w] = freqz(b, a, Rezol_p);
w_c = 2 * atan((W_c * Ts) / 2);

% Graficele Filtrului Tustin
figure(1);
subplot(1,3,1); F_plot_lin(w, H, w_c, M, Ts, omega_p, omega_s, Delta_p, Delta_s, 'Spectrul Filtrului Butterworth (Tustin)', 1);
subplot(1,3,2); F_plot_db(w, H, w_c, M, Ts, omega_p, omega_s, Delta_p, Delta_s, 'Spectrul Filtrului Butterworth (dB)', 1);
subplot(1,3,3); F_plot_faza(w, H, w_c, M, Ts, omega_p, omega_s, 'Faza Filtrului Butterworth', 1);
if print_title
    sgtitle('Răspunsul filtrului Butterworth (Tustin)');
end
disp(['(TUSTIN)    ','M = ', num2str(M), ', Omega_c = ', num2str(W_c), ' omega_c = ', num2str(w_c)]);

%% Faza 1 b)
disp(' ');
disp('Faza 1 b):');

[b_pt,a_pt,M_pt,W_c_pt] = But_FTI_PseudoTustin(omega_p/pi, omega_s/pi, Delta_p, Delta_s, Ts); 
[H_pt, ~] = freqz(b_pt, a_pt, Rezol_p);
w_c_pt = 2 * atan(W_c_pt * Ts);

% Graficele Noului Filtru Pseudo-Tustin
figure(2);
subplot(1,3,1); F_plot_lin(w, H_pt, w_c_pt, M_pt, Ts, omega_p, omega_s, Delta_p, Delta_s, 'Spectrul Filtrului Butterworth (Ps-Tustin)', 1);
subplot(1,3,2); F_plot_db(w, H_pt, w_c_pt, M_pt, Ts, omega_p, omega_s, Delta_p, Delta_s, 'Spectrul Filtrului Butterworth (dB)', 1);
subplot(1,3,3); F_plot_faza(w, H_pt, w_c_pt, M_pt, Ts, omega_p, omega_s, 'Faza Filtrului Butterworth', 1);
if print_title
    sgtitle('Răspunsul filtrului Butterworth (Pseudo-Tustin)');
end
disp(['(PS-TUSTIN) ','M = ', num2str(M_pt), ', Omega_c = ', num2str(W_c_pt), ' omega_c = ', num2str(w_c_pt)]);

%---calculul erorilor---%
err_lin = abs(H) - abs(H_pt);
norm_lin = norm(err_lin);
%-----------------------%
err_db = db(abs(H) + eps) - db(abs(H_pt) + eps); % eps ca să evităm NaN
norm_db = norm(err_db);
%-----------------------%
err_faza = unwrap(angle(H)) - unwrap(angle(H_pt));
norm_faza = norm(err_faza);

% Grafic Comparație
figure(3);
subplot(3,3,1); F_plot_lin(w, H, w_c, M, Ts, omega_p, omega_s, Delta_p, Delta_s, 'Tustin - Liniar', 1);
subplot(3,3,2); F_plot_db(w, H, w_c, M, Ts, omega_p, omega_s, Delta_p, Delta_s, 'Tustin - dB', 1);
subplot(3,3,3); F_plot_faza(w, H, w_c, M, Ts, omega_p, omega_s, 'Tustin - Faza', 1);
%-----------------------%
subplot(3,3,4); F_plot_lin(w, H_pt, w_c_pt, M_pt, Ts, omega_p, omega_s, Delta_p, Delta_s, 'PsTustin - Liniar', 1);
subplot(3,3,5); F_plot_db(w, H_pt, w_c_pt, M_pt, Ts, omega_p, omega_s, Delta_p, Delta_s, 'PsTustin - dB', 1);
subplot(3,3,6); F_plot_faza(w, H_pt, w_c_pt, M_pt, Ts, omega_p, omega_s, 'PsTustin - Faza', 1);
%-----------------------%
subplot(3,3,7); F_plot_err(w, err_lin, norm_lin, 'Eroare față de Butterworth', 'Ampl.');
subplot(3,3,8); F_plot_err(w, err_db, norm_db, 'Eroare față de Butterworth (dB)', 'dB');
subplot(3,3,9); F_plot_err(w, err_faza, norm_faza, 'Eroare față de Butterworth (fază)', 'rad');
%-----------------------%
if print_title
    sgtitle('Comparația celor 2 filtre (Tustin și Pseudo-Tustin)');
end
% a, b și a_pt, b_pt sunt identici:
disp('Diferența dintre coeficienții calculația:');
diff_b = norm(b - b_pt);
diff_a = norm(a - a_pt);
disp(['Norma diferenței coeficienților b: ', num2str(diff_b)]);
disp(['Norma diferenței coeficienților a: ', num2str(diff_a)]);

%% Faza 1 c)
% disp(' ');
% disp('Faza 1 c):');

% Tabel Mai Mic
Ts_labels_lw = {'0.1*Ts', 'Ts/4', 'Ts/2', '3*Ts/4'};
Ts_vals_lw   = [0.1*Ts, Ts/4, Ts/2, 3*Ts/4];

figure(4);
if print_title
    sgtitle('Set Ts_{c)} < Ts');
end
for k = 1:4
    Ts_xc = Ts_vals_lw(k);
    [b_xc, a_xc, M_xc, ~] = But_FTI_detailed(omega_p/pi, omega_s/pi, Delta_p, Delta_s, Ts_xc);
    [H_xc, ~] = freqz(b_xc, a_xc, w); 
    
    %---calculul erorilor---%
    % Calculăm totuși eroarea liniară, deși graficele sunt cerute în dB
    % err_db_xc = db(abs(H) + eps) - db(abs(H_xc) + eps);
        
    err_lin_xc = abs(H) - abs(H_xc);
    norm_lin_xc = norm(err_lin_xc);
    %-----------------------%
    err_faza_xc = unwrap(angle(H)) - unwrap(angle(H_xc));
    norm_faza_xc = norm(err_faza_xc);
    %-----------------------%

    % Coloană Grafice:
    subplot(4, 4, k); F_plot_db(w, H_xc,[], M_xc, Ts_xc, omega_p, omega_s, Delta_p, Delta_s, [Ts_labels_lw{k}, ' - dB']);
    subplot(4, 4, k+4); F_plot_err(w, err_lin_xc, norm_lin_xc, 'Eroare față de Butterworth', 'Ampl.');
    subplot(4, 4, k+8); F_plot_faza(w, H_xc, [], M_xc, Ts_xc, omega_p, omega_s, [Ts_labels_lw{k}, ' - Faza']);   
    subplot(4, 4, k+12); F_plot_err(w, err_faza_xc, norm_faza_xc, 'Eroare față de Butterworth (fază)', 'rad');

end

% Tabel Mai Mare
Ts_labels_gt = {'5*Ts/4', '7*Ts/4', '9*Ts/4', '3*Ts'};
Ts_vals_gt   = [5*Ts/4, 7*Ts/4, 9*Ts/4, 3*Ts];

figure(5);
if print_title
    sgtitle('Set Ts_{c)} > Ts');
end
for k = 1:4
    Ts_xc = Ts_vals_gt(k);
    [b_xc, a_xc, M_xc, ~] = But_FTI_detailed(omega_p/pi, omega_s/pi, Delta_p, Delta_s, Ts_xc);
    [H_xc, ~] = freqz(b_xc, a_xc, w);
    
    %---calculul erorilor---%
    % La fel și aici
    % err_db_xc = db(abs(H) + eps) - db(abs(H_xc) + eps);

    err_lin_xc = abs(H) - abs(H_xc);
    norm_lin_xc = norm(err_lin_xc);
    %-----------------------%
    err_faza_xc = unwrap(angle(H)) - unwrap(angle(H_xc));
    norm_faza_xc = norm(err_faza_xc);
    %-----------------------%

    % Coloană Grafice:
    subplot(4, 4, k); F_plot_db(w, H_xc, [], M_xc, Ts_xc, omega_p, omega_s, Delta_p, Delta_s, [Ts_labels_gt{k}, ' - dB']);
    subplot(4, 4, k+4); F_plot_err(w, err_lin_xc, norm_lin_xc, 'Eroare față de Butterworth', 'Ampl.');
    subplot(4, 4, k+8); F_plot_faza(w, H_xc, [], M_xc, Ts_xc, omega_p, omega_s, [Ts_labels_gt{k}, ' - Faza']);
    subplot(4, 4, k+12); F_plot_err(w, err_faza_xc, norm_faza_xc, 'Eroare față de Butterworth (fază)', 'rad');

end

%% Faza 1 d)
% disp(' ');
% disp('Faza 1 d):');

Delta_vals = [0.5, 1, 1.5, 2];

figure(6);
if print_title
    sgtitle('Analiza Toleranțelor - Set 1');
end
for i = 1:2
    for j = 1:4
        mp = Delta_vals(i);
        ms = Delta_vals(j);
        
        [b_xd, a_xd, M_xd, ~] = But_FTI_detailed(omega_p/pi, omega_s/pi, mp*Delta_p, ms*Delta_s, Ts);
        [H_xd, ~] = freqz(b_xd, a_xd, w);

        subplot(4,4, 8*(i-1) + j);
        F_plot_lin(w, H_xd, [], M_xd, Ts, omega_p, omega_s, mp*Delta_p, ms*Delta_s, sprintf('\\Delta_p=%.1f\\Delta_0 | \\Delta_s=%.1f\\Delta_0', mp, ms));
        subplot(4,4, 4 + 8*(i-1) + j);
        F_plot_faza(w, H_xd, [], M_xd, Ts, omega_p, omega_s,'Faza');

    end
end

figure(7);
if print_title
    sgtitle('Analiza Toleranțelor - Set 2');
end
for i = 3:4
    for j = 1:4
        mp = Delta_vals(i);
        ms = Delta_vals(j);

        [b_xd, a_xd, M_xd, ~] = But_FTI_detailed(omega_p/pi, omega_s/pi, mp*Delta_p, ms*Delta_s, Ts);
        [H_xd, ~] = freqz(b_xd, a_xd, w);

        i_aux = i - 2;
        subplot(4,4, 4*(i_aux-1)*2 + j)
        F_plot_lin(w, H_xd, [], M_xd, Ts, omega_p, omega_s, mp*Delta_p, ms*Delta_s, sprintf('\\Delta_p=%.1f\\Delta_0 | \\Delta_s=%.1f\\Delta_0', mp, ms));
        subplot(4,4, 4 + 8*(i_aux-1) + j);
        F_plot_faza(w, H_xd, [], M_xd, Ts, omega_p, omega_s, 'Faza');

    end
end

%% Faza 1 e)
disp(' ');
disp('Faza 1 e):');

% FIR 1
%----Putem calcula w_c iar, sau îl putem lua pe cel de la a)-----%
% Omega_p_xe = 2/Ts*tan(omega_p/2);
% Mp2_xe = (1 - Delta_p)^2;
% Omega_c_xe = Omega_p_xe / (((1-Mp2_xe)/Mp2_xe)^(1/(2*M)));
% omega_c_xe = 2 * atan(Omega_c_xe*Ts/2);
%----------------------------------------------------------------%

[h_fir1_xe, H_fir1_xe, M_fir1_min_xe, ok_fir1_xe] = F_find_best_fir1(M, w_c, w, omega_p, omega_s, Delta_p, Delta_s);
[h_firls_xe, H_firls_xe, M_firls_min_xe, ok_firls_xe] = F_find_best_firls(M, w, omega_p, omega_s, Delta_p, Delta_s);

%-Calculul erorilor față de Butterworth-%
err_lin_fir1 = abs(H) - abs(H_fir1_xe);
err_lin_firls = abs(H) - abs(H_firls_xe);
norm_lin_fir1 = norm(err_lin_fir1);
norm_lin_firls = norm(err_lin_firls);
%---------------------------------------%
err_db_fir1 = db(abs(H) + eps) - db(abs(H_fir1_xe) + eps);
err_db_firls = db(abs(H) + eps) - db(abs(H_firls_xe) + eps);
norm_db_fir1 = norm(err_db_fir1);
norm_db_firls = norm(err_db_firls);
%---------------------------------------%
err_faza_fir1 = unwrap(angle(H)) - unwrap(angle(H_fir1_xe));
err_faza_firls = unwrap(angle(H)) - unwrap(angle(H_firls_xe));
norm_faza_fir1 = norm(err_faza_fir1);
norm_faza_firls = norm(err_faza_firls);

% Graficele Aferente
figure(8);
subplot(4,3,1); F_plot_lin(w, H_fir1_xe, [], M_fir1_min_xe, [], omega_p, omega_s, Delta_p, Delta_s, 'Spectrul Filtrului Fir 1', 1);
subplot(4,3,2); F_plot_db(w, H_fir1_xe, [], M_fir1_min_xe, [], omega_p, omega_s, Delta_p, Delta_s, 'Spectrul Filtrului Fir 1 (dB)', 1);
subplot(4,3,3); F_plot_faza(w, H_fir1_xe, [], M_fir1_min_xe, [], omega_p, omega_s, 'Faza Filtrului Fir 1', 1);
subplot(4,3,4); F_plot_err(w, err_lin_fir1, norm_lin_fir1, 'Eroare față de Butterworth', 'Ampli.');
subplot(4,3,5); F_plot_err(w, err_db_fir1, norm_db_fir1, 'Eroare față de Butterworth (dB)', 'dB');
subplot(4,3,6); F_plot_err(w, err_faza_fir1, norm_faza_fir1, 'Eroare față de Butterworth (fază)', 'rad');
%----------------------------------------------%
subplot(4,3,7); F_plot_lin(w, H_firls_xe, [], M_firls_min_xe, [], omega_p, omega_s, Delta_p, Delta_s, 'Spectrul Filtrului Fir LowSq', 1);
subplot(4,3,8); F_plot_db(w, H_firls_xe, [], M_firls_min_xe, [], omega_p, omega_s, Delta_p, Delta_s, 'Spectrul Filtrului Fir LowSq (dB)', 1);
subplot(4,3,9); F_plot_faza(w, H_firls_xe, [], M_firls_min_xe, [], omega_p, omega_s, 'Faza Filtrului Fir LowSq', 1);
subplot(4,3,10); F_plot_err(w, err_lin_firls, norm_lin_firls, 'Eroare față de Butterworth', 'Ampl.');
subplot(4,3,11); F_plot_err(w, err_db_firls, norm_db_firls, 'Eroare față de Butterworth (dB)', 'dB');
subplot(4,3,12); F_plot_err(w, err_faza_firls, norm_faza_firls, 'Eroare față de Butterworth (fază)', 'rad');
%----------------------------------------------%
if print_title
    sgtitle('Analiza Filtrelor FIR1 și FIRLS, Comparație cu Butterworth');
end

disp(['(FIR 1)     M = ', num2str(M_fir1_min_xe)]);
disp(['(FIR LS)    M = ', num2str(M_firls_min_xe)]);