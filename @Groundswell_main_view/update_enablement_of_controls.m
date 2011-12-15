function update_enablement_of_controls(self)

% this enables/disables all elements of the main window to properly 
% reflect the current state of the view object

% get the figure handle
groundswell_figure_h=self.fig_h;

% get vars we need
n_chan=self.n_chan;
i_selected=self.i_selected;
n_selected=length(i_selected);

if n_chan==0
  % x axis menu
  set(findobj(groundswell_figure_h,'tag','time_ms_menu_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','time_s_menu_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','time_min_menu_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','time_hr_menu_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','edit_t_bounds_menu_h'),...
      'enable','off');
  % y axis menu
  set(findobj(groundswell_figure_h,'tag','optimize_all_y_menu_h'),...
      'enable','off');
  % buttons
  set(findobj(groundswell_figure_h,'tag','to_start_button_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','page_left_button_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','step_left_button_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','step_right_button_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','page_right_button_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','to_end_button_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','zoom_way_out_button_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','zoom_out_button_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','zoom_in_button_h'),'enable','off');
  % mutation menu
  set(findobj(groundswell_figure_h,'tag','center_menu_h'),'enable','off');
  set(findobj(groundswell_figure_h,'tag','rectify_menu_h'),'enable','off');
  % analysis menu
  set(findobj(groundswell_figure_h,'tag','spectra_menu_h'),'enable','off');  
  set(findobj(groundswell_figure_h,'tag','spectrograms_menu_h'),'enable','off');  
else
  % x axis menu
  set(findobj(groundswell_figure_h,'tag','time_ms_menu_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','time_s_menu_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','time_min_menu_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','time_hr_menu_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','edit_t_bounds_menu_h'),...
      'enable','on');
  % y axis menu
  set(findobj(groundswell_figure_h,'tag','optimize_all_y_menu_h'),...
      'enable','on');
  % buttons
  set(findobj(groundswell_figure_h,'tag','to_start_button_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','page_left_button_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','step_left_button_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','step_right_button_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','page_right_button_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','to_end_button_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','zoom_way_out_button_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','zoom_out_button_h'),'enable','on');
  set(findobj(groundswell_figure_h,'tag','zoom_in_button_h'),'enable','on');
  if n_selected==0
    % y axis menu
    set(findobj(groundswell_figure_h,'tag','edit_y_bounds_menu_h'),...
        'enable','off');
    set(findobj(groundswell_figure_h,'tag','optimize_selected_y_menu_h'),...
        'enable','off');
    % mutation menu
    set(findobj(groundswell_figure_h,'tag','center_menu_h'),'enable','off');
    set(findobj(groundswell_figure_h,'tag','rectify_menu_h'),'enable','off');
  else    
    % y axis menu
    set(findobj(groundswell_figure_h,'tag','edit_y_bounds_menu_h'),...
        'enable','on');
    set(findobj(groundswell_figure_h,'tag','optimize_selected_y_menu_h'),...
        'enable','on');
    % mutation menu
    set(findobj(groundswell_figure_h,'tag','center_menu_h'),'enable','on');
    set(findobj(groundswell_figure_h,'tag','rectify_menu_h'),'enable','on');
  end
  if n_selected==1
    % analysis menu
    set(findobj(groundswell_figure_h,'tag','power_spectrum_menu_h'),'enable','on');
    set(findobj(groundswell_figure_h,'tag','spectrogram_menu_h'),'enable','on');  
  else
    % analysis menu
    set(findobj(groundswell_figure_h,'tag','power_spectrum_menu_h'),'enable','off');
    set(findobj(groundswell_figure_h,'tag','spectrogram_menu_h'),'enable','off');  
  end    
  if n_selected==2
    % analysis menu
    set(findobj(groundswell_figure_h,'tag','coherency_menu_h'),'enable','on');
    set(findobj(groundswell_figure_h,'tag','coherogram_menu_h'),'enable','on');
    set(findobj(groundswell_figure_h,'tag','transfer_function_menu_h'),'enable','on');
  else
    % analysis menu
    set(findobj(groundswell_figure_h,'tag','coherency_menu_h'),'enable','off');
    set(findobj(groundswell_figure_h,'tag','coherogram_menu_h'),'enable','off');
    set(findobj(groundswell_figure_h,'tag','transfer_function_menu_h'),'enable','off');
  end
  if n_selected>=2
    set(self.coherency_at_f_probe_menu_h,'enable','on');
  else
    set(self.coherency_at_f_probe_menu_h,'enable','off');
  end  
end
