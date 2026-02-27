%
%	File F_PLOT_ERR.M
%
%	Function: F_plot_err
%
%	Synopsis: F_plot_err(w, err_vector, norm_val, title_str, ylabel_str)
%
%	Plots an error function evaluated over frequency and displays
%	the corresponding norm value for quantitative assessment.
%
%	The function is intended for analysis and comparison purposes
%	in digital filter design and evaluation tasks.
%
%	Inputs: w          = frequency vector [rad/sample];
%	        err_vector = error function evaluated on w;
%	        norm_val   = norm of the error vector;
%	        title_str  = plot title (string);
%	        ylabel_str = label for the vertical axis (string).
%
%	Missing, empty or inconsistent inputs may result in incomplete
%	or partially annotated plots.
%
%	Author: Badea Cătălin Gabriel - 331AC
%	Date:   26 Decembrie 2025
%

function F_plot_err(w, err_vector, norm_val, title_str, ylabel_str)
    
    plot(w, err_vector, 'r'); 
    grid on;
    %--------------------%
    xlim([0 pi]);
    %--------------------%
    title(title_str);
    xlabel('\omega [rad/sample]');
    ylabel(ylabel_str);
    %--------------------%
    text(0.03, 0.9, sprintf('Norma = %.2e', norm_val), 'Units', 'normalized', 'VerticalAlignment', 'middle');

end