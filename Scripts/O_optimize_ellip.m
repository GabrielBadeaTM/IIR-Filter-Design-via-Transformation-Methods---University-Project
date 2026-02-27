%
%	File O_OPTIMIZE_ELLIP.M
%
%	Function: O_optimize_ellip
%
%	Synopsis: [b_best, a_best, H_best, M_best, w_c_best, scor_best] = ...
%	          O_optimize_ellip(M_start, w, omega_p, omega_s, ...
%	                            Delta_p, Delta_s)
%
%	Optimizes the design of a digital elliptic (Cauer) low-pass
%	filter by searching for the optimal cutoff frequency and
%	filter order starting from an initial order M_start.
%
%	The function iteratively decreases the filter order while
%	scanning admissible cutoff frequencies in order to maximize
%	a custom performance score subject to the specified passband
%	and stopband tolerances.
%
%	Inputs: M_start = initial filter order;
%	        w       = frequency vector [rad/sample];
%	        omega_p = passband edge frequency [rad/sample];
%	        omega_s = stopband edge frequency [rad/sample];
%	        Delta_p = passband tolerance (linear scale);
%	        Delta_s = stopband tolerance (linear scale).
%
%	Outputs: b_best     = numerator coefficients of optimal filter;
%	         a_best     = denominator coefficients of optimal filter;
%	         H_best     = frequency response of optimal filter;
%	         M_best     = optimal filter order;
%	         w_c_best   = optimal cutoff frequency [rad/sample];
%	         scor_best  = best performance score obtained.
%
%	USES: ELLIP
%	      FREQZ
%	      F_CALCULARE_PERFORMANTA
%
%	If no valid filter satisfying the imposed constraints is found,
%	the output coefficients remain empty and a warning message is
%	displayed.
%
%	Author: Badea Cătălin Gabriel - 331AC
%	Date:   2 Ianuarie 2026
%

function [b_best, a_best, H_best, M_best, w_c_best, scor_best] = O_optimize_ellip(M_start, w, omega_p, omega_s, Delta_p, Delta_s)

    Rp = -20*log10(1-Delta_p);
    Rs = -20*log10(Delta_s);

    M = M_start;  
    M_best = M_start;

    score_best_temporary = -1;

    b_best = []; 
    a_best = []; 
    H_best = []; 
    w_c_best = omega_p;  % frecventa de taiere initiala

    scor_best = -1;

    w_c_vals = (w((w >= omega_p) & (w <= omega_s)))'; % valorile din w dintre w_p si w_s

    while M > 0

        found_valid = false;
        
        for w_c_i = w_c_vals
            [b, a] = ellip(M, Rp, Rs, w_c_i/pi);
            H = freqz(b, a, w);
            
            scor = F_calculare_performanta(H, M, w, omega_p, omega_s, Delta_p, Delta_s);
            
            if scor >= 0
                found_valid = true;
                if scor > score_best_temporary
                    score_best_temporary = scor;
                    b_best = b;
                    a_best = a;
                    H_best = H;
                    w_c_best = w_c_i;
                    M_best = M;
                    scor_best = scor;
                end
            end
        end
        
        if found_valid          % incercam si un M mai mic, în caz că nu am pornit inițial cu M minim.
            M = M - 1;
        else
            break;              % nu mai putem scadea M fara sa incalcam tolerantele
        end
    end

    if isempty(b_best)
        disp('Nu s-a gasit niciun filtru valid!');
    end
end
