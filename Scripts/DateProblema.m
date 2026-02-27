%% Date
ng = 3;
ns = 15;

% [omega_p,omega_s,Delta_p,Ts] = PS_PRJ_3_Faza_1a(ng,ns);
% omega_p_x3 = PS_PRJ_3_Faza_3(ng,ns);

% rezoluția graficelor
Rezol_p = 5000;

print_title = 1; % daca vrem să afișăm sgtitle-urile

%% Date Memorate:

% Faza 1;
Delta_p = 0.0723;
Delta_s = 0.0723;
omega_p = 1.2295;
omega_s = 1.3485;
Ts = 2.2757;

% Faza 2;
Delta_p_x2 = Delta_p;
Delta_s_x2 = 2*Delta_p;
% restul rămân neschimbate

% Faza 3;
% variabilele sunt rescrise în scriptul Fazei 3
% [omega_p_x3 (memorat) = 1.6574]
