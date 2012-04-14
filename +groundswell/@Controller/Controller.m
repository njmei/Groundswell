classdef Controller < handle
% This is Controller, a class to represent the 
% controller for the main window of the groundswell application.

properties
  model;
  view;
  fs_str;  % string holding the sampling rate, in Hz
  command_depressed;  % boolean, whether any mac command keys are depressed
end  % properties

methods
  function self=Controller(varargin)
    self.fs_str='';
    self.model=[];
    self.view=groundswell.View(self);
    self.command_depressed=false;  % probably
    % load the data, if given an arg
    if nargin==1 && ischar(varargin{1})
      filename=varargin{1};
      self.load_data(filename);
    end
  end  % constructor
  function center(self)
    self.model.center(self.view.i_selected);
    % update the view
    force_resample=true;
    self.view.refresh_traces(force_resample);
  end 
  function rectify(self)
    self.model.rectify(self.view.i_selected);
    % update the view
    force_resample=true;
    self.view.refresh_traces(force_resample);
  end
  function dx_over_x(self)
    self.model.dx_over_x(self.view.i_selected);
    % update the view
    self.view.units_changed();
    self.optimize_selected_y_axis_ranges();  % re-optimize range.
    force_resample=true;
    self.view.refresh_traces(force_resample);
  end
end  % methods
  
end  % classdef
