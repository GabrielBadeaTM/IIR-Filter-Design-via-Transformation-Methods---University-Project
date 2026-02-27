%% Salvare rezultate Faza 3
% Pulsatia de trecere
% omega_p = omega_p;

% H-urile si M-urile in ordinea clasamentului
H1 = filtre_sorted(1).H;
H2 = filtre_sorted(2).H;
H3 = filtre_sorted(3).H;
H4 = filtre_sorted(4).H;

M1 = filtre_sorted(1).M;
M2 = filtre_sorted(2).M;
M3 = filtre_sorted(3).M;
M4 = filtre_sorted(4).M;

% Numele filtrelor
H1_name = filtre_sorted(1).name;
H2_name = filtre_sorted(2).name;
H3_name = filtre_sorted(3).name;
H4_name = filtre_sorted(4).name;

% Salvare in fisier MAT
save('FiltreConcurs.mat', ...
    'omega_p', ...
    'H1', 'H2', 'H3', 'H4', ...
    'M1', 'M2', 'M3', 'M4', ...
    'H1_name', 'H2_name', 'H3_name', 'H4_name');
