
%% !!! DACĂ AM RULAT FAZA 3 ÎNAINTE, TREBUIE REÎNCĂRCATE DATELE DIN FAZA 1 !!!
%% Faza 4
disp(' ');
disp('Faza 4:');

[b_x4,a_x4,M_x4,W_c_x4] = But_FTI_amplified(omega_p/pi,omega_s/pi,Delta_p,Delta_s,Ts); 
[H_x4, w_x4] = freqz(b_x4,a_x4,Rezol_p);
w_c_x4 = 2 * atan((W_c_x4 * Ts) / 2);

figure(30);
subplot(1,3,1); F_plot_lin(w_x4, H_x4, w_c_x4, M_x4, Ts, omega_p, omega_s, Delta_p, Delta_s, 'Spectrul Filtrului Butterworth Amplificat', 1);
subplot(1,3,2); F_plot_db(w_x4, H_x4, w_c_x4, M_x4, Ts, omega_p, omega_s, Delta_p, Delta_s, 'Spectrul Filtrului Butterworth Amplificat (dB)', 1);
subplot(1,3,3); F_plot_faza(w_x4, H_x4, w_c_x4, M_x4, Ts, omega_p, omega_s, 'Faza Filtrului Butterworth Amplificat', 1);
if print_title
    sgtitle('Răspunsul filtrului Butterworth cu H(0) = 1 + \Delta_p');
end
disp(['M = ', num2str(M_x4), ', Omega_c = ', num2str(W_c_x4), ', omega_c = ', num2str(w_c_x4)]);
