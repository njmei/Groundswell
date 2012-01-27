classdef Model < handle

% This is Groundswell_main, a class to represent the underlying data
% in the main window of the groundswell application.

  properties
    t0;
    dt;
    t;  % This property is dependent in spirit, and could be made
        % dependent for real with no change in object semantics.  But we
        % keep it around for speed, because it's used frequently.
        % It's always equal to t0+dt*(0:(size(data,1)-1)' 
    data;
    names;
    units;
  end  % properties
  
  properties (Dependent=true)
    fs;  % Hz, sampling rate
    n_t;  % number of time samples
    n_chan;  % number of channels
    tl;  % 2x1 matrix holding min, max time
  end
  
  methods
    function self=Model(t,data,names,units)
      n_t=size(data,1);
      if n_t==0
        t0=nan;
        dt=nan;
      elseif n_t==1
        t0=t(1);
        dt=nan;
      else
        t0=t(1);
        dt=(t(end)-t0)/(n_t-1);
      end      
      self.t0=t0;
      self.dt=dt;
      self.data=data;
      self.names=names;
      self.units=units;
      self.sync_t();
    end  % function
    
    function fs=get.fs(self)
      fs=1/self.dt;
    end
    
    function n_t=get.n_t(self)
      n_t=size(self.data,1);
    end

    function n_chan=get.n_chan(self)
      n_chan=size(self.data,2);
    end

    function tl=get.tl(self)
      t0=self.t0;
      dt=self.dt;
      data=self.data;
      n_t=size(data,1);
      if n_t==0
        tl=[];
      else
        tl=t0+[0 dt*(n_t-1)];
      end
    end
    
    function set.dt(self,dt)
      self.dt=dt;
      self.sync_t();
    end
    
    function sync_t(self)
      t0=self.t0;
      dt=self.dt;
      n_t=size(self.data,1);
      self.t=t0+dt*(0:(n_t-1))';
    end

    function set.fs(self,fs)
      self.dt=1/fs;
    end
  end

end  % classdef
