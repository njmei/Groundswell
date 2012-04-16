classdef Model < handle

  properties
    t0;
    dt;
    t;  % This property is dependent in spirit, and could be made
        % dependent for real with no change in object semantics.  But we
        % keep it around for speed, because it's used frequently.
        % It's always equal to t0+dt*(0:(size(data,1)-1)' 
    data;  % Data in native units.  Each element is whatever data type 
           % it's in in the original file, usually uint8 or uint16.
    roi;  % n_roi x 1 struct with fields border and label
  end  % properties
  
  properties (Dependent=true)
    fs;  % Hz, sampling rate
    n_rows;
    n_cols;
    n_frames;  % number of time samples
    tl;  % 2x1 matrix holding min, max time
    n_rois;
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
      self.data=reshape(data_raw,[n_row n_col n_frame]);
      self.t0=t0;  % s
      self.dt=dt;  % s
      self.roi=struct('border',cell(0,1), ...
                      'label',cell(0,1));
    end  % function
    
    function fs=get.fs(self)
      fs=1/self.dt;
    end
    
    function n_row=get.n_rows(self)
      n_row=size(self.data,1);
    end
    
    function n_col=get.n_cols(self)
      n_col=size(self.data,2);
    end
    
    function n_frame=get.n_frames(self)
      n_frame=size(self.data,3);
    end
    
    function n_roi=get.n_rois(self)
      n_roi=length(self.roi);
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
      n_frame=self.n_frames;
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
    
    function in_use=label_in_use(self,label_test)
      labels={self.roi.label};
      in_use=any(strcmp(label_test,labels));
    end

    function motion_correct(self)
      border=2;  % border to ignore, seems to help with nans and such at the
                 % edge of the frames
      % find the translation for each frame
      options=optimset('maxfunevals',1000);
      n_frames=size(self.data,3);
      b_per_frame=zeros(2,n_frames);
      for k=2:n_frames
        b_per_frame(:,k)=...
          find_translation(double(self.data(:,:,1)), ...
                           double(self.data(:,:,k)), ...
                           border,...
                           b_per_frame(:,k-1),...
                           options);
      end
      % register each frame using the above-determined translation
      for k=2:n_frames
        % implicit conversion to the type of self.data
        self.data(:,:,k)=register_frame(double(self.data(:,:,k)), ...
                                        eye(2), ...
                                        b_per_frame(:,k));
      end      
    end  % motion_correct
    
    function [d_min,d_max]=data_bounds(self)
      % d_min and d_max are doubles, regardless the type of self.data
      d_min=+inf;
      d_max=-inf;
      for i=1:self.n_frames
        frame=double(self.data(:,:,i));
        d_min=min(d_min,min(min(frame)));
        d_max=max(d_max,max(max(frame)));
      end
    end  % data_bounds
    
    function [h,t]=hist(self,n_bins)
      for i=1:self.n_frames
        frame=double(self.data(:,:,i));
        [h_this,t_this]=hist(frame(:),n_bins);
        if i==1
          t=t_this;  h=h_this;
        else
          h=h+h_this;
        end
      end
    end

    function [h,t]=hist_abs(self,n_bins)
      for i=1:self.n_frames
        frame=double(self.data(:,:,i));
        [h_this,t_this]=hist(abs(frame(:)),n_bins);
        if i==1
          t=t_this;  h=h_this;
        else
          h=h+h_this;
        end
      end
    end

    function [d_05,d_95]=five_95(self)
      % d_05 and d_95 are doubles, regardless the type of self.data
      n_bins=1000;
      [h,t]=self.hist(n_bins);
      ch=cumsum(h);
      % figure; plot(t,ch);
      d_05=crossing_times(t,ch,0.05*ch(n_bins));
      d_95=crossing_times(t,ch,0.95*ch(n_bins));
    end  % five_95
    
    function d_max=max_abs(self)
      % d_max is a double, regardless of the type of self.data
      d_max=-inf;
      for i=1:self.n_frames
        frame=double(self.data(:,:,i));
        d_max=max(d_max,max(max(abs(frame))));
      end
    end  % max_abs
    
    function d_90=abs_90(self)
      % d_90 is a double, regardless the type of self.data
      n_bins=1000;
      [h,t]=self.hist_abs(n_bins);
      ch=cumsum(h);
      % figure; plot(t,ch);
      d_90=crossing_times(t,ch,0.90*ch(n_bins));
    end  % five_95
    
    function [d_min,d_max]=default_bounds(self)
      if isa(self.data,'uint8')
        d_min=0;
        d_max=255;
      elseif isa(self.data,'uint16')
        d_min=0;
        d_max=65535;
      else
        % why not?
        d_min=0;
        d_max=1;
      end
        
    end
    
  end  % methods

end  % classdef
