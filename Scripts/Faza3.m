%% Specificatii Faza 3
disp(' ');
disp('Faza 3:');

% Date Faza 3;
Delta_p = 0.05;
Delta_s = 10^(-30 / 20);
Ts = 2.2757;
omega_p = 1.6574;
omega_s = omega_p + pi/33;
Rezol_p = 5000;

% print_title e in scriptul DateProblema

%% Generare Filtre
% Butterworth
[b_but_x3, a_but_x3, M_but_init_x3, W_c_x3] = But_FTI_detailed(omega_p/pi, omega_s/pi, Delta_p, Delta_s, Ts);
[H_but_x3, w] = freqz(b_but_x3, a_but_x3, Rezol_p);
w_c_x3= 2 * atan((W_c_x3 * Ts) / 2);
scor_butter = F_calculare_performanta(H_but_x3, M_but_init_x3, w, omega_p, omega_s, Delta_p, Delta_s);
% Cheby1
[~, ~, H_cheb1_x3, M_found_cheb1_x3, ~] = F_find_best_cheby1(M_but_init_x3, w, omega_p, omega_s, Delta_p, Delta_s);
scor_cheby1 = F_calculare_performanta(H_cheb1_x3, M_found_cheb1_x3, w, omega_p, omega_s, Delta_p, Delta_s);
% Cheby2
[~, ~, H_cheb2_x3, M_found_cheb2_x3, ~] = F_find_best_cheby2(M_but_init_x3, w, omega_p, omega_s, Delta_p, Delta_s);
scor_cheby2 = F_calculare_performanta(H_cheb2_x3, M_found_cheb2_x3, w, omega_p, omega_s, Delta_p, Delta_s);
% Eliptic
[~, ~, H_ellip_x3, M_found_ellip_x3, ~] = F_find_best_ellip(M_but_init_x3, w, omega_p, omega_s, Delta_p, Delta_s);
scor_ellip = F_calculare_performanta(H_ellip_x3, M_found_ellip_x3, w, omega_p, omega_s, Delta_p, Delta_s);

% Scoruri
disp(['Scor Butterworth = ', num2str(scor_butter),'  M = ', num2str(M_but_init_x3)]);
disp(['Scor Cheby1 = ', num2str(scor_cheby1), '  M = ', num2str(M_found_cheb1_x3)]);
disp(['Scor Cheby2 = ', num2str(scor_cheby2), '  M = ', num2str(M_found_cheb2_x3)]);
disp(['Scor Ellip = ', num2str(scor_ellip), '  M = ', num2str(M_found_ellip_x3)]);

% Optimizări
[~, ~, H_cheb1_best_x3, M_best_cheb1_x3, w_c_best_cheb1, scor_best_cheby1] = O_optimize_cheby1(M_found_cheb1_x3, w, omega_p, omega_s, Delta_p, Delta_s);
[~, ~, H_cheb2_best_x3, M_best_cheb2_x3, w_c_best_cheb2, scor_best_cheby2] = O_optimize_cheby2(M_found_cheb2_x3, w, omega_p, omega_s, Delta_p, Delta_s);
[~, ~, H_ellip_best_x3, M_best_ellip_x3, w_c_best_ellip, scor_best_ellip] = O_optimize_ellip(M_found_ellip_x3, w, omega_p, omega_s, Delta_p, Delta_s);

% Scoruri Noi
disp(' ');
disp('Scoruri noi, după optimizarea lui W_c');
disp('-------------------------------------');
disp(['Scor Butterworth (optim) = ', num2str(scor_butter),'  M = ', num2str(M_but_init_x3)]);
disp(['Scor Cheby1 (optim) = ', num2str(scor_best_cheby1), '  M = ', num2str(M_best_cheb1_x3), '  w_c = ', num2str(w_c_best_cheb1)]);
disp(['Scor Cheby2 (optim) = ', num2str(scor_best_cheby2), '  M = ', num2str(M_best_cheb2_x3), '  w_c = ', num2str(w_c_best_cheb2)]);
disp(['Scor Ellip (optim) = ', num2str(scor_best_ellip), '  M = ', num2str(M_best_ellip_x3),  '  w_c = ', num2str(w_c_best_ellip)]);


%% Clasament filtre Faza 3
filtre(1) = struct('name','Butterworth', 'scor',scor_butter, 'M',M_but_init_x3, 'H',H_but_x3, 'w_c',w_c_x3);
filtre(2) = struct('name','Cheby1',      'scor',scor_best_cheby1, 'M',M_best_cheb1_x3, 'H',H_cheb1_best_x3, 'w_c',w_c_best_cheb1);
filtre(3) = struct('name','Cheby2',      'scor',scor_best_cheby2, 'M',M_best_cheb2_x3, 'H',H_cheb2_best_x3, 'w_c',w_c_best_cheb2);
filtre(4) = struct('name','Cauer',       'scor',scor_best_ellip, 'M',M_best_ellip_x3, 'H',H_ellip_best_x3, 'w_c',w_c_best_ellip);

[~, idx_sort] = sort([filtre.scor], 'descend');
filtre_sorted = filtre(idx_sort);

disp(' ');
disp('Clasament filtre Faza 3:');
for k = 1:4
    fprintf('%d. %s  | Scor = %.5f | Ordin M = %d\n', k, filtre_sorted(k).name, filtre_sorted(k).scor, filtre_sorted(k).M);
end

%% Plotarea filtrelor in ordinea clasamentului
figure(20);
for k = 1:4
    subplot(2,4,k); F_plot_lin(w, filtre_sorted(k).H, [], filtre_sorted(k).M, Ts, omega_p, omega_s, Delta_p, Delta_s, [num2str(k) ,'. Spectrul Filtrului ', filtre_sorted(k).name], 1);
    subplot(2,4,k+4); F_plot_faza(w, filtre_sorted(k).H, [], filtre_sorted(k).M, Ts, omega_p, omega_s, ['Criteriu Performanță: ', num2str(filtre_sorted(k).scor),newline,newline,'Faza Filtrului ',filtre_sorted(k).name], 1);
end
if print_title
    sgtitle('Analiza Filtrelor - Clasament');
end