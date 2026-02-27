%
%	File F_PLOT_LIN.M
%
%	Function: F_plot_lin
%
%	Synopsis: F_plot_lin(w, H, w_c, M, Ts, omega_p, omega_s, ...
%	                     Delta_p, Delta_s, title_str, show)
%
%	Plots the linear-magnitude frequency response |H(e^{jω})|
%	of a digital filter and overlays the main design parameters,
%	such as passband and stopband limits, tolerances and (optionally)
%	the cutoff frequency.
%
%	The function is intended for analysis and visualization purposes
%	in digital filter design problems.
%
%	Inputs: w         = frequency vector [rad/sample];
%	        H         = frequency response evaluated on w;
%	        w_c       = cutoff frequency (optional, may be empty or NaN);
%	        M         = filter order;
%	        Ts        = sampling period used in the design (optional);
%	        omega_p   = passband edge frequency [rad/sample];
%	        omega_s   = stopband edge frequency [rad/sample];
%	        Delta_p   = passband tolerance;
%	        Delta_s   = stopband tolerance;
%	        title_str = plot title (string);
%	        show      = flag for enabling/disabling labels (1 = show).
%
%	Missing, empty or inconsistent inputs may result in incomplete
%	or partially annotated plots.
%
%	Author: Badea Cătălin Gabriel - 331AC
%	Date:   26 Decembrie 2025
%

function F_plot_lin (w, H, w_c, M, Ts, omega_p, omega_s, Delta_p, Delta_s, title_str, show)
   
    % În caz că nu vrem label-urile
    l_wp=''; l_ws=''; l_ds=''; l_dp1=''; l_dp2='';
    if nargin >= 11 && show == 1
        l_wp='\omega_p';
        l_ws='\omega_s';
        l_ds='\Delta_s';
        l_dp1='1 + \Delta_p';
        l_dp2='1 - \Delta_p';
    end

    plot(w,abs(H),'k');
    hold on;
    grid on;
    %--------------------%
    if ~isempty(w_c) && ~isnan(w_c)
        plot(w_c, 1/(sqrt(2)), 'xm'); % punctul butterworth de la 0.707
        
        l_wc = '';
        if nargin >= 11 && show == 1
            l_wc = '\omega_c';
        end
        xline(w_c, 'r--', l_wc, 'LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    end
    %--------------------%
    xline(omega_p,'k--',l_wp);
    xline(omega_s,'k--',l_ws);
    yline(Delta_s,'r--',l_ds);
    yline(1+Delta_p,'b--',l_dp1);
    yline(1-Delta_p,'b--',l_dp2);
    %--------------------%
    xlim([0 pi]);
    ylim([-0.1 1.15]);
    %--------------------%
    title(title_str);
    xlabel('\omega [rad/sample]');
    ylabel('|H(e^{j\omega})|');
    %--------------------%
    info_str = sprintf('M = %.0f', M);
    if ~isempty(Ts) && ~isnan(Ts)
        info_str = [info_str, sprintf('\nTs = %.3f', Ts)]; % Adaugam Ts optional
    end
    text(0.03, 0.5, info_str, 'Units','normalized','VerticalAlignment','middle');
end