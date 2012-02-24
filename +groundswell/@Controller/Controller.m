classdef Controller < handle
% This is Controller, a class to represent the 
% controller for the main window of the groundswell application.

properties
  model;
  view;
  fs_str;  % string holding the sampling rate, in Hz
end  % properties

methods
  function self=Controller()
    self.fs_str='';
    self.model=[];
    self.view=groundswell.View(self);
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
  
end  % classdef
