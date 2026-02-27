%
%	File F_PLOT_FAZA.M
%
%	Function: F_plot_faza
%
%	Synopsis: F_plot_faza(w, H, w_c, M, Ts, omega_p, omega_s, ...
%	                      title_str, show)
%
%	Plots the unwrapped phase response ∠H(e^{jω}) of a digital filter
%	and overlays the main characteristic frequencies used in the
%	design process, such as passband, stopband and (optionally)
%	the cutoff frequency.
%
%	The function is intended for analysis and visualization purposes
%	in digital filter design.
%
%	Inputs: w         = frequency vector [rad/sample];
%	        H         = frequency response evaluated on w;
%	        w_c       = cutoff frequency (optional, may be empty or NaN);
%	        M         = filter order;
%	        Ts        = sampling period used in the design (optional);
%	        omega_p   = passband edge frequency [rad/sample];
%	        omega_s   = stopband edge frequency [rad/sample];
%	        title_str = plot title (string);
%	        show      = flag for enabling/disabling labels (1 = show).
%
%	Missing, empty or inconsistent inputs may result in incomplete
%	or partially annotated plots.
%
%	Author: Badea Cătălin Gabriel - 331AC
%	Date:   26 Decembrie 2025
%

function F_plot_faza (w, H, w_c, M, Ts, omega_p, omega_s, title_str, show)
 
    % În caz că nu vrem label-urile
    l_wp=''; l_ws='';
    if nargin >= 9 && show == 1
        l_wp='\omega_p';
        l_ws='\omega_s';
    end

    plot(w,unwrap(angle(H)));
    grid on;
    %--------------------%
    if ~isempty(w_c) && ~isnan(w_c)
        l_wc = '';
        if nargin >= 9 && show == 1
            l_wc = '\omega_c';
        end
        xline(w_c, 'r--', l_wc, 'LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    end
    %--------------------%
    xline(omega_p,'k--',l_wp);
    xline(omega_s,'k--',l_ws);
    %--------------------%
    xlim([0 pi]);
    %--------------------%
    title(title_str);
    xlabel('\omega [rad/sample]');
    ylabel('\angle H(e^{j\omega}) [rad]');
    %--------------------%
    info_str = sprintf('M = %.0f', M);
    if ~isempty(Ts) && ~isnan(Ts)
        info_str = [info_str, sprintf('\nTs = %.3f', Ts)];
    end
    text(0.03, 0.5, info_str, 'Units','normalized','VerticalAlignment','middle');
end