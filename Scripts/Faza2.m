%% Faza 2 a)
disp(' ');
disp('Faza 2 a):');

[b_x2a,a_x2a,M_x2a,W_c_x2a] = But_FTI_detailed(omega_p/pi,omega_s/pi,Delta_p_x2,Delta_s_x2,Ts); 
[H_x2a, w] = freqz(b_x2a,a_x2a,Rezol_p);
w_c_x2a = 2 * atan((W_c_x2a * Ts) / 2);

[~, ~, H_ellip_x2a, M_ellip_min_x2a, ok] = F_find_best_ellip(M_x2a, w, omega_p, omega_s, Delta_p_x2, Delta_s_x2);

%---calculul erorilor---%
err_lin = abs(H_x2a) - abs(H_ellip_x2a);
norm_lin = norm(err_lin);
%-----------------------%
err_db = db(abs(H_x2a) + eps) - db(abs(H_ellip_x2a) + eps);
norm_db = norm(err_db);
%-----------------------%
err_faza = unwrap(angle(H_x2a)) - unwrap(angle(H_ellip_x2a));
norm_faza = norm(err_faza);

figure(11);
subplot(3,3,1); F_plot_lin(w, H_x2a, [], M_x2a, Ts, omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Spectrul Filtrului Butterworth (Tustin)');
subplot(3,3,2); F_plot_db(w, H_x2a, [], M_x2a, Ts, omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Spectrul Filtrului Butterworth (dB)');
subplot(3,3,3); F_plot_faza(w, H_x2a, [], M_x2a, Ts, omega_p, omega_s, 'Faza Filtrului Butterworth');
%----------------------------------------------%
subplot(3,3,4); F_plot_lin(w, H_ellip_x2a, [], M_ellip_min_x2a, [], omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Spectrul Filtrului Eliptic');
subplot(3,3,5); F_plot_db(w, H_ellip_x2a, [], M_ellip_min_x2a, [], omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Spectrul Filtrului Eliptic (dB)');
subplot(3,3,6); F_plot_faza(w, H_ellip_x2a, [], M_ellip_min_x2a, [], omega_p, omega_s, 'Faza Filtrului Eliptic');
%----------------------------------------------%
subplot(3,3,7); F_plot_err(w, err_lin, norm_lin, 'Eroare față de Butterworth', 'Ampl.');
subplot(3,3,8); F_plot_err(w, err_db, norm_db, 'Eroare față de Butterworth (dB)', 'dB');
subplot(3,3,9); F_plot_err(w, err_faza, norm_faza, 'Eroare față de Butterworth (fază)', 'rad');
%----------------------------------------------%
if print_title
    sgtitle('Comparație Butterworth - Elliptic');
end
disp(['M_Butterworth = ', num2str(M_x2a), ', M_Eliptic = ', num2str(M_ellip_min_x2a)]);

%% Faza 2 b)
disp(' ');
disp('Faza 2 b):');

[h_fir1_x2b, H_fir1_x2b, M_fir1_min_x2b, ok_fir1_x2b] = F_find_best_fir1(M_x2a, w_c_x2a, w, omega_p, omega_s, Delta_p_x2, Delta_s_x2);
[h_firls_x2b, H_firls_x2b, M_firls_min_x2b, ok_firls_x2b] = F_find_best_firls(M_x2a, w, omega_p, omega_s, Delta_p_x2, Delta_s_x2);

%---calculul erorilor---%
err_lin_fir1_x2b = abs(H_x2a) - abs(H_fir1_x2b);
err_lin_firls_x2b = abs(H_x2a) - abs(H_firls_x2b);
norm_lin_fir1_x2b = norm(err_lin_fir1_x2b);
norm_lin_firls_x2b = norm(err_lin_firls_x2b);
%-----------------------%
err_db_fir1_x2b = db(abs(H_x2a) + eps) - db(abs(H_fir1_x2b) + eps);
err_db_firls_x2b = db(abs(H_x2a) + eps) - db(abs(H_firls_x2b) + eps);
norm_db_fir1_x2b = norm(err_db_fir1_x2b);
norm_db_firls_x2b = norm(err_db_firls_x2b);
%-----------------------%
err_faza_fir1_x2b = unwrap(angle(H_x2a)) - unwrap(angle(H_fir1_x2b));
err_faza_firls_x2b = unwrap(angle(H_x2a)) - unwrap(angle(H_firls_x2b));
norm_faza_fir1_x2b = norm(err_faza_fir1_x2b);
norm_faza_firls_x2b = norm(err_faza_firls_x2b);

figure(12);
subplot(4,3,1); F_plot_lin(w, H_fir1_x2b, [], M_fir1_min_x2b, [], omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Filtru Fir 1', 1);
subplot(4,3,2); F_plot_db(w, H_fir1_x2b, [], M_fir1_min_x2b, [], omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Filtru Fir 1 (dB)', 1);
subplot(4,3,3); F_plot_faza(w, H_fir1_x2b, [], M_fir1_min_x2b, [], omega_p, omega_s, 'Faza Filtrului Fir 1', 1);
subplot(4,3,4); F_plot_err(w, err_lin_fir1_x2b, norm_lin_fir1_x2b, 'Eroare față de Butterworth', 'Amplitudine');
subplot(4,3,5); F_plot_err(w, err_db_fir1_x2b, norm_db_fir1_x2b, 'Eroare față de Butterworth (dB)', 'dB');
subplot(4,3,6); F_plot_err(w, err_faza_fir1_x2b, norm_faza_fir1_x2b, 'Eroare fază față de Butterworth', 'rad');
%----------------------------------------------%
subplot(4,3,7); F_plot_lin(w, H_firls_x2b, [], M_firls_min_x2b, [], omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Filtru Fir LowSq', 1);
subplot(4,3,8); F_plot_db(w, H_firls_x2b, [], M_firls_min_x2b, [], omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Filtru Fir LowSq (dB)', 1);
subplot(4,3,9); F_plot_faza(w, H_firls_x2b, [], M_firls_min_x2b, [], omega_p, omega_s, 'Faza Filtrului Fir LowSq', 1);
subplot(4,3,10); F_plot_err(w, err_lin_firls_x2b, norm_lin_firls_x2b, 'Eroare față de Butterworth', 'Amplitudine');
subplot(4,3,11); F_plot_err(w, err_db_firls_x2b, norm_db_firls_x2b, 'Eroare față de Butterworth (dB)', 'dB');
subplot(4,3,12); F_plot_err(w, err_faza_firls_x2b, norm_faza_firls_x2b, 'Eroare fază față de Butterworth', 'rad');
%----------------------------------------------%
if print_title
    sgtitle('Comparație Butterworth - Filtre FIR');
end
disp(['M_fir1 = ', num2str(M_fir1_min_x2b), ', M_firls = ', num2str(M_firls_min_x2b)]);

%% Faza 2 c)
disp(' ');
disp('Faza 2 c):');

[b_c1, a_c1, H_cheb1_x2c, M_cheb1_min_x2c, ok_c1] = F_find_best_cheby1(M_x2a, w, omega_p, omega_s, Delta_p_x2, Delta_s_x2);
[b_c2, a_c2, H_cheb2_x2c, M_cheb2_min_x2c, ok_c2] = F_find_best_cheby2(M_x2a, w, omega_p, omega_s, Delta_p_x2, Delta_s_x2);

%---calculul erorilor---%
err_lin_c1 = abs(H_x2a) - abs(H_cheb1_x2c);
err_lin_c2 = abs(H_x2a) - abs(H_cheb2_x2c);
norm_lin_c1 = norm(err_lin_c1);
norm_lin_c2 = norm(err_lin_c2);
%-----------------------%
err_db_c1  = db(abs(H_x2a) + eps) - db(abs(H_cheb1_x2c) + eps);
err_db_c2  = db(abs(H_x2a) + eps) - db(abs(H_cheb2_x2c) + eps);
norm_db_c1 = norm(err_db_c1);
norm_db_c2 = norm(err_db_c2);
%-----------------------%
err_faza_c1 = unwrap(angle(H_x2a)) - unwrap(angle(H_cheb1_x2c));
err_faza_c2 = unwrap(angle(H_x2a)) - unwrap(angle(H_cheb2_x2c));
norm_faza_c1 = norm(err_faza_c1);
norm_faza_c2 = norm(err_faza_c2);

figure(13);
subplot(4,3,1);  F_plot_lin(w, H_cheb1_x2c, [], M_cheb1_min_x2c, [], omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Filtru Cebîșev I', 1);
subplot(4,3,2);  F_plot_db(w, H_cheb1_x2c, [], M_cheb1_min_x2c, [], omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Filtru Cebîșev I (dB)', 1);
subplot(4,3,3);  F_plot_faza(w, H_cheb1_x2c, [], M_cheb1_min_x2c, [], omega_p, omega_s, 'Faza Filtrului Cebîșev I', 1);
subplot(4,3,4);  F_plot_err(w, err_lin_c1, norm_lin_c1, 'Eroare față de Butterworth', 'Amplitudine');
subplot(4,3,5);  F_plot_err(w, err_db_c1, norm_db_c1, 'Eroare față de Butterworth (dB)', 'dB');
subplot(4,3,6);  F_plot_err(w, err_faza_c1, norm_faza_c1, 'Eroare fază față de Butterworth', 'rad');
%----------------------------------------------%
subplot(4,3,7);  F_plot_lin(w, H_cheb2_x2c, [], M_cheb2_min_x2c, [], omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Filtru Cebîșev II', 1);
subplot(4,3,8);  F_plot_db(w, H_cheb2_x2c, [], M_cheb2_min_x2c, [], omega_p, omega_s, Delta_p_x2, Delta_s_x2, 'Filtru Cebîșev II (dB)', 1);
subplot(4,3,9);  F_plot_faza(w, H_cheb2_x2c, [], M_cheb2_min_x2c, [], omega_p, omega_s, 'Faza Filtrului Cebîșev II', 1);
subplot(4,3,10); F_plot_err(w, err_lin_c2, norm_lin_c2, 'Eroare față de Butterworth', 'Amplitudine');
subplot(4,3,11); F_plot_err(w, err_db_c2, norm_db_c2, 'Eroare față de Butterworth (dB)', 'dB');
subplot(4,3,12); F_plot_err(w, err_faza_c2, norm_faza_c2, 'Eroare fază față de Butterworth', 'rad');
%----------------------------------------------%
if print_title
    sgtitle('Comparație Butterworth – Filtre Cebîșev');
end
disp(['M_Cebîșev I = ', num2str(M_cheb1_min_x2c), ', M_Cebîșev II = ', num2str(M_cheb2_min_x2c)]);