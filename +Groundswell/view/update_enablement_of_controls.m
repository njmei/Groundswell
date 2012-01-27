function update_enablement_of_controls(self)

% this enables/disables all elements of the main window to properly 
% reflect the current state of the view object

% get vars we need
n_chan=self.n_chan;
i_selected=self.i_selected;
n_selected=length(i_selected);

if n_chan==0
  % x axis menu
  set(self.time_ms_menu_h,'enable','off');
  set(self.time_s_menu_h,'enable','off');
  set(self.time_min_menu_h,'enable','off');
  set(self.time_hr_menu_h,'enable','off');
  set(self.edit_t_bounds_menu_h,'enable','off');
  % y axis menu
  set(self.optimize_all_y_menu_h,'enable','off');
  % buttons
  set(self.to_start_button_h,'enable','off');
  set(self.page_left_button_h,'enable','off');
  set(self.step_left_button_h,'enable','off');
  set(self.step_right_button_h,'enable','off');
  set(self.page_right_button_h,'enable','off');
  set(self.to_end_button_h,'enable','off');
  set(self.zoom_way_out_button_h,'enable','off');
  set(self.zoom_out_button_h,'enable','off');
  set(self.zoom_in_button_h,'enable','off');
  % mutation menu
  set(self.change_fs_menu_h,'enable','off');
  set(self.center_menu_h,'enable','off');
  set(self.rectify_menu_h,'enable','off');
  % analysis menu
  set(self.spectra_menu_h,'enable','off');  
  set(self.spectrograms_menu_h,'enable','off');  
  set(self.power_spectrum_menu_h,'enable','off');
  set(self.coherency_menu_h,'enable','off');
  set(self.coherogram_menu_h,'enable','off');
  set(self.transfer_function_menu_h,'enable','off');
  set(self.coherency_at_f_probe_menu_h,'enable','off');
  set(self.play_as_audio_menu_h,'enable','off');
else
  % x axis menu
  set(self.time_ms_menu_h,'enable','on');
  set(self.time_s_menu_h,'enable','on');
  set(self.time_min_menu_h,'enable','on');
  set(self.time_hr_menu_h,'enable','on');
  set(self.edit_t_bounds_menu_h,'enable','on');
  % y axis menu
  set(self.optimize_all_y_menu_h,'enable','on');
  % buttons
  set(self.to_start_button_h,'enable','on');
  set(self.page_left_button_h,'enable','on');
  set(self.step_left_button_h,'enable','on');
  set(self.step_right_button_h,'enable','on');
  set(self.page_right_button_h,'enable','on');
  set(self.to_end_button_h,'enable','on');
  set(self.zoom_way_out_button_h,'enable','on');
  set(self.zoom_out_button_h,'enable','on');
  set(self.zoom_in_button_h,'enable','on');
  % mutation menu
  set(self.change_fs_menu_h,'enable','on');
  if n_selected==0
    % y axis menu
    set(self.edit_y_bounds_menu_h,'enable','off');
    set(self.optimize_selected_y_menu_h,'enable','off');
    % mutation menu
    set(self.center_menu_h,'enable','off');
    set(self.rectify_menu_h,'enable','off');
  else    
    % y axis menu
    set(self.edit_y_bounds_menu_h,'enable','on');
    set(self.optimize_selected_y_menu_h,'enable','on');
    % mutation menu
    set(self.center_menu_h,'enable','on');
    set(self.rectify_menu_h,'enable','on');
  end
  if n_selected==1
    % analysis menu
    set(self.power_spectrum_menu_h,'enable','on');
    set(self.spectrogram_menu_h,'enable','on');  
    set(self.play_as_audio_menu_h,'enable','on');
  else
    % analysis menu
    set(self.power_spectrum_menu_h,'enable','off');
    set(self.spectrogram_menu_h,'enable','off');  
    set(self.play_as_audio_menu_h,'enable','off');
  end    
  if n_selected==2
    % analysis menu
    set(self.coherency_menu_h,'enable','on');
    set(self.coherogram_menu_h,'enable','on');
    set(self.transfer_function_menu_h,'enable','on');
    set(self.play_as_audio_menu_h,'enable','off');
  else
    % analysis menu
    set(self.coherency_menu_h,'enable','off');
    set(self.coherogram_menu_h,'enable','off');
    set(self.transfer_function_menu_h,'enable','off');
  end
  if n_selected>=2
    set(self.coherency_at_f_probe_menu_h,'enable','on');
    set(self.play_as_audio_menu_h,'enable','off');
  else
    set(self.coherency_at_f_probe_menu_h,'enable','off');
  end  
end
