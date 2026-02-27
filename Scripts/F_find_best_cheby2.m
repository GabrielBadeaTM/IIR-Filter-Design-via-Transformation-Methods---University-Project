%
%	File F_FIND_BEST_CHEBY2.M
%
%	Function: F_find_best_cheby2
%
%	Synopsis: [b_cheb, a_cheb, H_cheb, M_found, ok] = ...
%	          F_find_best_cheby2(M, w, omega_p, omega_s, ...
%	                              Delta_p, Delta_s, Max_M)
%
%	Searches for a Chebyshev Type II digital low-pass filter that
%	satisfies given passband and stopband specifications by
%	iteratively adjusting the filter order.
%
%	The function starts from an initial order M and increases or
%	decreases it in order to find the minimum order that fulfills
%	the imposed tolerance constraints.
%
%	Inputs: M         = initial filter order;
%	        w         = frequency vector [rad/sample];
%	        omega_p   = passband edge frequency [rad/sample];
%	        omega_s   = stopband edge frequency [rad/sample];
%	        Delta_p   = passband tolerance (linear scale);
%	        Delta_s   = stopband tolerance (linear scale);
%	        Max_M     = maximum allowed filter order (optional).
%
%	Outputs: b_cheb   = numerator coefficients of the Chebyshev filter;
%	         a_cheb   = denominator coefficients of the Chebyshev filter;
%	         H_cheb   = frequency response evaluated on w;
%	         M_found  = filter order that satisfies the specifications;
%	         ok       = logical flag indicating successful design.
%
%	Missing, empty or inconsistent inputs may lead to failure in
%	finding a valid filter configuration.
%
%	Uses: CHEBY2, FREQZ
%
%	Author: Badea Cătălin Gabriel - 331AC
%	Date:   29 Decembrie 2025
%

function [b_cheb, a_cheb, H_cheb, M_found, ok] = F_find_best_cheby2(M, w, omega_p, omega_s, Delta_p, Delta_s, Max_M)
    
    % default Max_M
    if nargin < 7
        Max_M = 1000;
    end
    
    % Caracteristica Cheby2
    Rs = -20*log10(Delta_s);
    
    banda_pass = w <= omega_p;
    banda_stop = w >= omega_s;
    
    % Și cheby din matlab nu lucreaza cu ordine asa mari, da eroare
    if M > 15
        M_found = 15;
    else
        M_found = M;
    end
    
    ok = false;
    
    [b_cheb, a_cheb] = cheby2(M_found, Rs, omega_s/pi);
    [H_cheb, ~] = freqz(b_cheb, a_cheb, w); 
    H_pass = H_cheb(banda_pass);
    H_stop = H_cheb(banda_stop);
    
    ok_init = all(abs(H_pass) <= 1 + Delta_p) && all(abs(H_pass) >= 1 - Delta_p) && all(abs(H_stop) <= Delta_s);
    
    if ok_init == false 
        % M prea mic -> crestem ordinul
        while M_found < Max_M
            M_found = M_found + 1;
            
            [b_cheb, a_cheb] = cheby2(M_found, Rs, omega_s/pi);
            [H_cheb, ~] = freqz(b_cheb, a_cheb, w); 
            H_pass = H_cheb(banda_pass);
            H_stop = H_cheb(banda_stop);
            
            verificare = all(abs(H_pass) <= 1 + Delta_p) && all(abs(H_pass) >= 1 - Delta_p) && all(abs(H_stop) <= Delta_s);
            if verificare
                ok = true;
                break;
            end
        end
    else
        % M e bun din prima -> cautam un ordin mai mic
        ok = true;
        while M_found > 1
            M_found = M_found - 1;
            
            [b_cheb, a_cheb] = cheby2(M_found, Rs, omega_s/pi);
            [H_cheb, ~] = freqz(b_cheb, a_cheb, w); 
            H_pass = H_cheb(banda_pass);
            H_stop = H_cheb(banda_stop);
            
            verificare = all(abs(H_pass) <= 1 + Delta_p) && all(abs(H_pass) >= 1 - Delta_p) && all(abs(H_stop) <= Delta_s);
            if ~verificare
                M_found = M_found + 1;
                [b_cheb, a_cheb] = cheby2(M_found, Rs, omega_s/pi);
                [H_cheb, ~] = freqz(b_cheb, a_cheb, w);
                break;
            end
        end
    end
end