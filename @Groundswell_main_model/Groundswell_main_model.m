classdef Groundswell_main_model < handle

% This is Groundswell_main, a class to represent the underlying data
% in the main window of the groundswell application.

  properties
    t;
    data;
    names;
    units;
  end  % properties
  
  methods
    function self=Groundswell_main_model()
      self.t=[];
      self.data=[];
      self.names=[];
      self.units=[];
    end  % function
  end

end  % classdef
