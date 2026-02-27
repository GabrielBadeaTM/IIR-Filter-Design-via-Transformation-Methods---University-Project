%
%	File F_FIND_BEST_ELLIP.M
%
%	Function: F_find_best_ellip
%
%	Synopsis: [b_ellip, a_ellip, H_ellip, M_found, ok] = ...
%	          F_find_best_ellip(M, w, omega_p, omega_s, ...
%	                             Delta_p, Delta_s, Max_M)
%
%	Searches for an Elliptic (Cauer) digital low-pass filter that
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
%	Outputs: b_ellip = numerator coefficients of the Elliptic filter;
%	         a_ellip = denominator coefficients of the Elliptic filter;
%	         H_ellip = frequency response evaluated on w;
%	         M_found = filter order that satisfies the specifications;
%	         ok      = logical flag indicating successful design.
%
%	Missing, empty or inconsistent inputs may lead to failure in
%	finding a valid filter configuration.
%
%	Uses: ELLIP, FREQZ
%
%	Author: Badea Cătălin Gabriel - 331AC
%	Date:   29 Decembrie 2025
%

function [b_ellip, a_ellip, H_ellip, M_found, ok] = F_find_best_ellip(M, w, omega_p, omega_s, Delta_p, Delta_s, Max_M)
    
    % default Max_M
    if nargin < 7
        Max_M = 1000;
    end

    % Caracteristicile filtrului eliptic
    Rp = -20*log10(1-Delta_p);
    Rs = -20*log10(Delta_s);
    
    banda_pass = w <= omega_p;
    banda_stop = w >= omega_s;

    % ellip din matlab nu lucreaza cu ordine asa mari, da eroare
    if M > 10
        M_found = 10;
    else
        M_found = M;
    end

    ok = false;
    % Verificare Initiala
    [b_ellip, a_ellip] = ellip(M_found,Rp,Rs,omega_p/pi);
    [H_ellip, ~] = freqz(b_ellip,a_ellip,w); 
    H_ellip_pass = H_ellip(banda_pass);
    H_ellip_stop = H_ellip(banda_stop);

    ok_init = all(abs(H_ellip_pass) <= 1 + Delta_p) &&  all(abs(H_ellip_pass) >= 1 - Delta_p) && all(abs(H_ellip_stop) <= Delta_s);
    if ok_init == false 
        % M prea mic -> crestem ordinul
        while M_found < Max_M
            M_found = M_found + 1;
            
            [b_ellip, a_ellip] = ellip(M_found,Rp,Rs,omega_p/pi);
            [H_ellip, ~] = freqz(b_ellip,a_ellip,w); 
            H_ellip_pass = H_ellip(banda_pass);
            H_ellip_stop = H_ellip(banda_stop);
            verificare = all(abs(H_ellip_pass) <= 1 + Delta_p) && all(abs(H_ellip_pass) >= 1 - Delta_p) && all(abs(H_ellip_stop) <= Delta_s);
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
            
            [b_ellip, a_ellip] = ellip(M_found,Rp,Rs,omega_p/pi);
            [H_ellip, ~] = freqz(b_ellip,a_ellip,w); 
            H_ellip_pass = H_ellip(banda_pass);
            H_ellip_stop = H_ellip(banda_stop);
            
            verificare = all(abs(H_ellip_pass) <= 1 + Delta_p) && all(abs(H_ellip_pass) >= 1 - Delta_p) && all(abs(H_ellip_stop) <= Delta_s);
            if ~verificare
                M_found = M_found + 1;
                [b_ellip, a_ellip] = ellip(M_found,Rp,Rs,omega_p/pi);
                [H_ellip, ~] = freqz(b_ellip,a_ellip,w);
                break;
            end
        end
    end
end