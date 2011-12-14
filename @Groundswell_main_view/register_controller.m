function register_controller(self,controller)

% let the view know who's its controller is
self.controller=controller;

% set all the figure callbacks to methods of the controller
set(self.fig_h,'ResizeFcn',@(src,event)(controller.resize()));
% now that the fig has a resize handler, allow resizing.
set(self.fig_h,'Resize','on');

% file menu
set(self.open_menu_h,'Callback',@(src,event)(controller.load_data()));
set(self.quit_menu_h,'Callback',@(src,event)(controller.quit()));
% the x-axis menu
set(self.time_ms_menu_h,'Callback',@(src,event)(controller.set_x_units('time_ms')));
set(self.time_s_menu_h,'Callback',@(src,event)(controller.set_x_units('time_s')));
set(self.time_min_menu_h,'Callback',@(src,event)(controller.set_x_units('time_min')));
set(self.time_hr_menu_h,'Callback',@(src,event)(controller.set_x_units('time_hr')));
set(self.edit_t_bounds_menu_h,'Callback',@(src,event)(controller.edit_t_bounds()));
% the y-axis menu
set(self.edit_y_bounds_menu_h,'Callback',@(src,event)(controller.edit_y_bounds()));
set(self.optimize_selected_y_menu_h,'Callback',@(src,event)(controller.optimize_selected_y_axis_ranges()));
set(self.optimize_all_y_menu_h,'Callback',@(src,event)(controller.optimize_all_y_axis_ranges()));
% the mutation menu
set(self.center_menu_h,'Callback',@(src,event)(controller.center()));
set(self.rectify_menu_h,'Callback',@(src,event)(controller.rectify()));
% the analysis menu
set(self.power_spectrum_menu_h,'Callback',@(src,event)(controller.power_spectrum()));
set(self.spectrogram_menu_h,'Callback',@(src,event)(controller.spectrogram()));
set(self.coherency_menu_h,'Callback',@(src,event)(controller.coherency()));
set(self.coherogram_menu_h,'Callback',@(src,event)(controller.coherogram()));
set(self.transfer_function_menu_h,'Callback',@(src,event)(controller.transfer_function()));
% scroll buttons
set(self.to_start_button_h,'Callback',@(src,event)(controller.to_start()));
set(self.page_left_button_h,'Callback',@(src,event)(controller.page_left()));
set(self.step_left_button_h,'Callback',@(src,event)(controller.step_left()));
set(self.step_right_button_h,'Callback',@(src,event)(controller.step_right()));
set(self.page_right_button_h,'Callback',@(src,event)(controller.page_right()));
set(self.to_end_button_h,'Callback',@(src,event)(controller.to_end()));
% zoom buttons
set(self.zoom_way_out_button_h,'Callback',@(src,event)(controller.zoom_way_out()));
set(self.zoom_out_button_h,'Callback',@(src,event)(controller.zoom_out()));
set(self.zoom_in_button_h,'Callback',@(src,event)(controller.zoom_in()));
