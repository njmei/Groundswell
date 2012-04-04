classdef Model < handle

  properties
    t0;
    dt;
    t;  % This property is dependent in spirit, and could be made
        % dependent for real with no change in object semantics.  But we
        % keep it around for speed, because it's used frequently.
        % It's always equal to t0+dt*(0:(size(data,1)-1)' 
    data;  % Data in native units.  Always a double array, but
           % typically not with pels on [0,1].
    roi;  % n_roi x 1 struct with fields border and label
  end  % properties
  
  properties (Dependent=true)
    fs;  % Hz, sampling rate
    n_row;
    n_col;
    n_frame;  % number of time samples
    tl;  % 2x1 matrix holding min, max time
  end
  
  methods
    function self=Model(data_raw,dt,t0)
      % get dims, make sure data_raw is 3D
      dims=ndims(data_raw);
      if (dims>3)
        error('data_raw must have three or less dimensions');
      end
      n_row=size(data_raw,1);
      n_col=size(data_raw,2);
      if dims>=3
        n_frame=size(data_raw,3);
      else
        n_frame=1;
      end
      self.data=double(reshape(data_raw,[n_row n_col n_frame]));
      self.t0=t0;  % s
      self.dt=dt;  % s
      self.roi=struct('border',cell(0,1), ...
                      'label',cell(0,1));
    end  % function
    
    function fs=get.fs(self)
      fs=1/self.dt;
    end
    
    function n_row=get.n_row(self)
      n_row=size(self.data,1);
    end
    
    function n_col=get.n_col(self)
      n_col=size(self.data,2);
    end
    
    function n_frame=get.n_frame(self)
      n_frame=size(self.data,3);
    end

    function tl=get.tl(self)
      t0=self.t0;
      dt=self.dt;
      n_frame=self.n_frame;
      if n_frame==0
        tl=[];
      else
        tl=t0+[0 dt*(n_frame-1)];
      end
    end
    
    function set.dt(self,dt)
      self.dt=dt;
      self.sync_t();
    end
    
    function sync_t(self)
      t0=self.t0;
      dt=self.dt;
      n_frame=self.n_frame;
      self.t=t0+dt*(0:(n_frame-1))';
    end

    function set.fs(self,fs)
      self.dt=1/fs;
    end
    
    function add_roi(self,border,label)
      % border 2 x n_vertex, label a string
      n_roi_old=length(self.roi);
      self.roi(n_roi_old+1).border=border;
      self.roi(n_roi_old+1).label=label;
    end
    
    function delete_rois(self,i_to_delete)
      keep=true(size(self.roi));
      keep(i_to_delete)=false;
      self.roi=self.roi(keep);
    end
    
    function set_roi(self,border,label)
      % border, label cell arrays
      n_roi=length(border);
      self.roi=struct('border',cell(n_roi,1), ...
                      'label',cell(n_roi,1));
      [self.roi.border]=deal(border{:});
      [self.roi.label]=deal(label{:});
    end
    
  end  % methods

end  % classdef
