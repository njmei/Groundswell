classdef Groundswell_main_controller < handle

% This is Groundswell_main_controller, a class to represent the 
% controller for the main window of the groundswell application.

  properties
    model;
    view;
  end  % properties
  
  methods
    function self=Groundswell_main_controller()
      self.model=Groundswell_main_model();
      self.view=Groundswell_main_view(self.model);
      self.view.register_controller(self);
    end  % constructor
    function resize(gsmc)
      gsmc.view.resize();
    end
    function to_start(gsmc)
      gsmc.view.to_start();
    end
    function page_left(gsmc)
      gsmc.view.page_left();
    end
    function step_left(gsmc)
      gsmc.view.step_left();
    end
    function step_right(gsmc)
      gsmc.view.step_right();
    end
    function page_right(gsmc)
      gsmc.view.page_right();
    end
    function to_end(gsmc)
      gsmc.view.to_end();
    end
    function zoom_in(gsmc)
      gsmc.view.zoom_in();
    end
    function zoom_out(gsmc)
      gsmc.view.zoom_out();
    end
    function zoom_way_out(gsmc)
      gsmc.view.zoom_way_out();
    end
    function center(gsmc)
      gsmc.model.center(gsmc.view.i_selected);
      % update the view
      force_resample=true;
      gsmc.view.refresh_traces(force_resample);
    end 
    function rectify(gsmc)
      gsmc.model.rectify(gsmc.view.i_selected);
      % update the view
      force_resample=true;
      gsmc.view.refresh_traces(force_resample);
    end
    function optimize_selected_y_axis_ranges(gsmc)
      gsmc.view.optimize_selected_y_axis_ranges();
    end
    function optimize_all_y_axis_ranges(gsmc)
      gsmc.view.optimize_all_y_axis_ranges();
    end
    function change_plot_x_axis(gsmc,new_plot_x_axis)
      gsmc.view.change_plot_x_axis(new_plot_x_axis);
    end
    function quit(gsmc)
      close(gsmc.view.fig_h);
    end
  end  % methods

  methods (Static)
    retval=get_coherogram_params(tl,dt)
    retval=get_spectrogram_params(tl,dt)
    result=all_on_same_time_base(t_each)
    [t,data]=upsample_to_common(t_each,data_each)
  end  % methods (Static)
  
end  % classdef
