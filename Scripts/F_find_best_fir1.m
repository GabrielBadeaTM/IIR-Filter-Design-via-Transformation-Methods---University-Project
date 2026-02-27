%
%	File F_FIND_BEST_FIR1.M
%
%	Function: F_find_best_fir1
%
%	Synopsis: [h_fir1, H_fir1, M_found, ok] = ...
%	          F_find_best_fir1(M, w_c, w, omega_p, omega_s, ...
%	                           Delta_p, Delta_s, Max_M)
%
%	Searches for a FIR1 low-pass filter that satisfies given
%	passband and stopband specifications by iteratively adjusting
%	the filter order.
%
%	The function starts from an initial order M and increases or
%	decreases it in order to find the minimum order that fulfills
%	the imposed tolerance constraints.
%
%	Inputs: M         = initial filter order;
%	        w_c       = cutoff frequency for FIR1 [rad/sample];
%	        w         = frequency vector [rad/sample];
%	        omega_p   = passband edge frequency [rad/sample];
%	        omega_s   = stopband edge frequency [rad/sample];
%	        Delta_p   = passband tolerance (linear scale);
%	        Delta_s   = stopband tolerance (linear scale);
%	        Max_M     = maximum allowed filter order (optional).
%
%	Outputs: h_fir1   = FIR filter coefficients;
%	         H_fir1   = frequency response evaluated on w;
%	         M_found  = filter order that satisfies the specifications;
%	         ok       = logical flag indicating successful design.
%
%	Missing, empty or inconsistent inputs may lead to failure in
%	finding a valid filter configuration.
%
%	Uses: FIR1, FREQZ
%
%	Author: Badea Cătălin Gabriel - 331AC
%	Date:   28 Decembrie 2025
%

function [h_fir1, H_fir1, M_found, ok] = F_find_best_fir1(M, w_c, w, omega_p, omega_s, Delta_p, Delta_s, Max_M)
    
    % default Max_M
    if nargin < 8
        Max_M = 1000;
    end
    
    banda_pass = w <= omega_p;
    banda_stop = w >= omega_s;

    M_found = M;
    ok = false;
    
    % Verificare Initiala
    h_fir1 = fir1(M_found-1, w_c/pi);
    [H_fir1, ~] = freqz(h_fir1,1,w);
    H_fir1_pass = H_fir1(banda_pass);
    H_fir1_stop = H_fir1(banda_stop);

    ok_init = all(abs(H_fir1_pass) <= 1 + Delta_p) &&  all(abs(H_fir1_pass) >= 1 - Delta_p) && all(abs(H_fir1_stop) <= Delta_s);
    if ok_init == false 
        % M prea mic -> crestem ordinul
        while M_found < Max_M
            M_found = M_found + 1;
            
            h_fir1 = fir1(M_found-1, w_c/pi);
            [H_fir1, ~] = freqz(h_fir1,1,w);
            H_fir1_pass = H_fir1(banda_pass);
            H_fir1_stop = H_fir1(banda_stop);
            verificare = all(abs(H_fir1_pass) <= 1 + Delta_p) && all(abs(H_fir1_pass) >= 1 - Delta_p) && all(abs(H_fir1_stop) <= Delta_s);
            if verificare
                ok = true;
                break;
            end
        end
    else
        % (cazul celălalt) M e bun din prima -> cautam un ordin mai mic
        ok = true;
        while M_found > 1
            M_found = M_found - 1;
            
            h_fir1 = fir1(M_found-1, w_c/pi);
            [H_fir1, ~] = freqz(h_fir1,1,w);
            H_fir1_pass = H_fir1(banda_pass);
            H_fir1_stop = H_fir1(banda_stop);
            
            verificare = all(abs(H_fir1_pass) <= 1 + Delta_p) && all(abs(H_fir1_pass) >= 1 - Delta_p) && all(abs(H_fir1_stop) <= Delta_s);
            if ~verificare
                M_found = M_found + 1;
                h_fir1 = fir1(M_found-1, w_c/pi);
                [H_fir1, ~] = freqz(h_fir1,1,w);
                break;
            end
        end
    end
end