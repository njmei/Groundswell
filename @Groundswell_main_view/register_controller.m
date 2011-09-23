function register_controller(gsmv,gsmc)

% let the view know who's its controller is
gsmv.controller=gsmc;

% set all the figure callbacks to methods of the controller
set(gsmv.fig_h,'ResizeFcn',@(src,event)(gsmc.resize()));
% now that the fig has a resize handler, allow resizing.
set(gsmv.fig_h,'Resize','on');

% file menu
set(gsmv.open_menu_h,'Callback',@(src,event)(gsmc.load_data()));
set(gsmv.quit_menu_h,'Callback',@(src,event)(gsmc.quit()));
% the x-axis menu
set(gsmv.time_ms_menu_h,'Callback',@(src,event)(gsmc.change_plot_x_axis('time_ms')));
set(gsmv.time_s_menu_h,'Callback',@(src,event)(gsmc.change_plot_x_axis('time_s')));
set(gsmv.time_min_menu_h,'Callback',@(src,event)(gsmc.change_plot_x_axis('time_min')));
set(gsmv.time_hr_menu_h,'Callback',@(src,event)(gsmc.change_plot_x_axis('time_hr')));
set(gsmv.edit_t_bounds_menu_h,'Callback',@(src,event)(gsmc.edit_t_bounds()));
% the y-axis menu
set(gsmv.edit_y_bounds_menu_h,'Callback',@(src,event)(gsmc.edit_y_bounds()));
set(gsmv.optimize_selected_y_menu_h,'Callback',@(src,event)(gsmc.optimize_selected_y_axis_ranges()));
set(gsmv.optimize_all_y_menu_h,'Callback',@(src,event)(gsmc.optimize_all_y_axis_ranges()));
% the mutation menu
set(gsmv.center_menu_h,'Callback',@(src,event)(gsmc.center()));
set(gsmv.rectify_menu_h,'Callback',@(src,event)(gsmc.rectify()));
% the analysis menu
set(gsmv.power_spectrum_menu_h,'Callback',@(src,event)(gsmc.power_spectrum()));
set(gsmv.spectrogram_menu_h,'Callback',@(src,event)(gsmc.spectrogram()));
set(gsmv.coherency_menu_h,'Callback',@(src,event)(gsmc.coherency()));
set(gsmv.coherogram_menu_h,'Callback',@(src,event)(gsmc.coherogram()));
set(gsmv.transfer_function_menu_h,'Callback',@(src,event)(gsmc.transfer_function()));
% scroll buttons
set(gsmv.to_start_button_h,'Callback',@(src,event)(gsmc.to_start()));
set(gsmv.page_left_button_h,'Callback',@(src,event)(gsmc.page_left()));
set(gsmv.step_left_button_h,'Callback',@(src,event)(gsmc.step_left()));
set(gsmv.step_right_button_h,'Callback',@(src,event)(gsmc.step_right()));
set(gsmv.page_right_button_h,'Callback',@(src,event)(gsmc.page_right()));
set(gsmv.to_end_button_h,'Callback',@(src,event)(gsmc.to_end()));
% zoom buttons
set(gsmv.zoom_way_out_button_h,'Callback',@(src,event)(gsmc.zoom_way_out()));
set(gsmv.zoom_out_button_h,'Callback',@(src,event)(gsmc.zoom_out()));
set(gsmv.zoom_in_button_h,'Callback',@(src,event)(gsmc.zoom_in()));
