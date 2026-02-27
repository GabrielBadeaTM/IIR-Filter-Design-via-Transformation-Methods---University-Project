%
%	File F_CALCULARE_PERFORMANTA.M
%
%	Function: F_calculare_performanta
%
%	Synopsis: scorPerform = F_calculare_performanta(H, M, w, ...
%	                                               omega_p, omega_s, ...
%	                                               Delta_p, Delta_s)
%
%	Calculates a normalized performance score for a digital filter
%	that satisfies given passband and stopband specifications.
%
%	The score combines the following criteria:
%	  - filter complexity (order M),
%	  - closeness to the ideal magnitude response
%	    (weighted passband and stopband error),
%	  - transition sharpness between omega_p and omega_s,
%	  - average stopband attenuation.
%
%	The criteria are weighted and combined into a single scalar score.
%	Higher values indicate better overall performance.
%
%	Inputs:
%	  H        = frequency response of the filter (complex values);
%	  M        = filter order;
%	  w        = frequency vector [rad/sample];
%	  omega_p  = passband edge frequency [rad/sample];
%	  omega_s  = stopband edge frequency [rad/sample];
%	  Delta_p  = passband tolerance (linear scale);
%	  Delta_s  = stopband tolerance (linear scale).
%
%	Output:
%	  scorPerform = performance score (higher is better);
%	                 returns -1 if the filter violates the
%	                 passband or stopband specifications.
%
%	Notes:
%	  - The score is approximately normalized in the interval [0, 1]
%	    for valid filters.
%	  - A value of -1 indicates an invalid filter.
%
%	Uses: NORM
%
%	Author: Badea Cătălin Gabriel - 331AC
%	Date:   30 Decembrie 2025
%

function scorPerform = F_calculare_performanta(H, M, w, omega_p, omega_s, Delta_p, Delta_s)

    %---parametri de scalare---%
    M0 = 60;     % ordin caracteristic
    A0 = 60;     % atenuare "bună" de referință (dB)
    E0 = 0.15;   % eroare caracteristica

    wM = 0.50;  % pondere complexitate
    wE = 0.40;  % pondere performanta
    wT = 0.05;  % pondere T_score
    wA = 0.05;  % pondere atenuare

    banda_pass = w <= omega_p;
    banda_stop = w >= omega_s;
    H_pass = H(banda_pass);
    H_stop = H(banda_stop);


    %% condiție obligatorie
    ok = all(abs(H_pass) < 1 + Delta_p) &&  all(abs(H_pass) > 1 - Delta_p) && all(abs(H_stop) < Delta_s);
    if ~ok
        scorPerform = -1;
        return;
    end

    %% performanțe principale
    % calculul apropierii de filtrul real - ponderat cu lungimea benzilor
    err_pass = norm(abs(1 - abs(H_pass))) / sqrt(length(H_pass));
    err_stop = norm(abs(0 - abs(H_stop))) / sqrt(length(H_stop));
    wp = 1.5 * length(H_pass) / length(H);
    ws = length(H_stop) / length(H);
    err_filter = wp*err_pass + ws*err_stop;
    %-------------------------------------%
    E_score = 1 - exp(-err_filter / E0);

    % calculul penalizarii ordinului
    M_score = 1 - exp(-M / M0);


    %% performanțe auxiliare
    % calculul vitezei de coborare
    w_cut_idx = find(w > omega_p & abs(H) <= Delta_s, 1, 'first'); % prima frecventa dupa omega_p unde filtrul coboara sub Delta_s
    if isempty(w_cut_idx)
        T_score = 1; % nu coboara suficient
    else
        w_cut = w(w_cut_idx);
        T_score = (w_cut - omega_p) / (omega_s - omega_p);
        T_score = min(max(T_score,0),1);
    end

    % calculul atenuarii medii
    atten_med = -mean(20*log10(abs(H_stop) + eps));
    A_score = -(1 - exp(-atten_med / A0)); % minusul aici simbolizeaza ca un filtru cu o atenuare mai mare este mai buna. asa pastram consistenta in formula finala.

    %% scor final;
    scorPerform = 1 - wM*M_score - wE*E_score - wT*T_score - wA*A_score;

end
