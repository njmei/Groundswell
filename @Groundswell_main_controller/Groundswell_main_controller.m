classdef Groundswell_main_controller < handle

% This is Groundswell_main_controller, a class to represent the 
% controller for the main window of the groundswell application.

  properties
    model;
    view;
    fs_str;  % string holding the sampling rate, in Hz
  end  % properties
  
  methods
    function self=Groundswell_main_controller()
      fs_str=[];
      self.model=[];
      self.view=Groundswell_main_view(self);
    end  % constructor
    function center(self)
      self.model.center(self.view.i_selected);
      % update the view
      force_resample=true;
      self.view.refresh_traces(self.model,force_resample);
    end 
    function rectify(self)
      self.model.rectify(self.view.i_selected);
      % update the view
      force_resample=true;
      self.view.refresh_traces(self.model,force_resample);
    end
    function quit(self)
      close(self.view.fig_h);
    end
  end  % methods

  methods (Static)
    retval=get_coherogram_params(tl,dt)
    retval=get_spectrogram_params(tl,dt)
    result=all_on_same_time_base(t_each)
    [t,data]=upsample_to_common(t_each,data_each)
    [t,data,trace_name]=load_txt_bayley(filename)
    p=is_bayley_style(filename)
  end  % methods (Static)
  
end  % classdef
