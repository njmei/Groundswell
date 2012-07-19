classdef Model < handle

  properties
    t0;
    dt;
    file;  % the handle of a VideoFile object, the current file    
    roi;  % n_roi x 1 struct with fields border and label
    overlay_file;  
      % an Overlay_file_reader object containing frame overlays, or empty
  end  % properties
  
  properties (Dependent=true)
    fs;  % Hz, sampling rate for playback, possibly different from that in file
    n_rows;
    n_cols;
    n_frames;  % number of time samples
    tl;  % 2x1 matrix holding min, max time
    n_rois;
    t;  % a complete timeline for all frames
  end
  
  methods
    function self=Model(file,dt,t0)
      self.file=file;
      self.t0=t0;  % s
      self.dt=dt;  % s
      self.roi=struct('border',cell(0,1), ...
                      'label',cell(0,1));
      self.overlay_file=[];                    
    end  % function
    
    function t=get.t(self)
      t=self.t0+self.dt*(0:(self.n_frames-1))';
    end
    
    function fs=get.fs(self)
      fs=1/self.dt;
    end
    
    function n_row=get.n_rows(self)
      n_row=self.file.n_row;
    end
    
    function n_col=get.n_cols(self)
      n_col=self.file.n_col;
    end
    
    function n_frame=get.n_frames(self)
      n_frame=self.file.n_frame;
    end
    
    function n_roi=get.n_rois(self)
      n_roi=length(self.roi);
    end

    function tl=get.tl(self)
      t0=self.t0;
      dt=self.dt;
      n_frame=self.n_frames;
      if n_frame==0
        tl=[];
      else
        tl=t0+[0 dt*(n_frame-1)];
      end
    end
    
    function set.dt(self,dt)
      self.dt=dt;
    end
    
%     function sync_t(self)
%       t0=self.t0;
%       dt=self.dt;
%       n_frame=self.n_frames;
%       self.t=t0+dt*(0:(n_frame-1))';
%     end

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

    function frame=get_frame(self,i)
      frame=self.file.get_frame(i);
    end

    function frame_overlay=get_frame_overlay(self,i)
      if (1<=i) && (i<=self.overlay_file.n_frames)
        frame_overlay=self.overlay_file.read_frame_overlay(i);
      else
        frame_overlay=cell(0,1);  % just return empty overlay
      end
    end
    
%   Since we now are keeping the movie on-disk, mutating it becomes 
%   more problematical...
%     function motion_correct(self)
%       border=2;  % border to ignore, seems to help with nans and such at the
%                  % edge of the frames
%       % find the translation for each frame
%       options=optimset('maxfunevals',1000);
%       n_frames=self.n_frames;
%       self.file.to_start();
%       if n_frames>0
%         frame_first=double(self.file.get_next());
%       end
%       b_per_frame=zeros(2,n_frames);
%       for k=2:n_frames
%         frame_this=double(self.file.get_next());
%         b_per_frame(:,k)=...
%           find_translation(frame_first, ...
%                            frame_this, ...
%                            border,...
%                            b_per_frame(:,k-1),...
%                            options);
%       end
%       % register each frame using the above-determined translation
%       for k=2:n_frames
%         % implicit conversion to the type of self.data
%         self.data(:,:,k)=register_frame(double(self.data(:,:,k)), ...
%                                         eye(2), ...
%                                         b_per_frame(:,k));
%       end      
%     end  % motion_correct
    
    function [d_min,d_max]=data_bounds(self)
      % d_min and d_max are doubles, regardless the type of self.data
      d_min=+inf;
      d_max=-inf;
      self.file.to_start();
      for i=1:self.n_frames
        frame=double(self.file.get_next());
        d_min=min(d_min,min(min(frame)));
        d_max=max(d_max,max(max(frame)));
      end
    end  % data_bounds
    
    function [h,t]=hist(self,n_bins)
      self.file.to_start();
      for i=1:self.n_frames
        frame=double(self.file.get_next());
        [h_this,t_this]=hist(frame(:),n_bins);
        if i==1
          t=t_this;  h=h_this;
        else
          h=h+h_this;
        end
      end
    end

    function [h,t]=hist_abs(self,n_bins)
      self.file.to_start();
      for i=1:self.n_frames
        frame=double(self.file.get_next());
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
      self.file.to_start();
      for i=1:self.n_frames
        frame=double(self.file.get_next());
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
      if self.file.bits_per_pel==8
        d_min=0;
        d_max=255;
      elseif self.file.bits_per_pel==16
        d_min=0;
        d_max=65535;
      else
        % This should not ever happen.
        d_min=0;
        d_max=1;
      end
        
    end

    function x_roi=mean_over_rois(self)
      % get a mask for each roi
      n_rows=self.n_rows;
      n_cols=self.n_cols;
      roi_stack= ...
        roving.roi_list_to_stack(self.roi,n_rows,n_cols);
      
      % analyze each of the rois
      n_frames=self.n_frames;
      n_rois=self.n_rois;
      n_pels=reshape(sum(sum(roi_stack,2),1),[n_rois 1]);  % pels in each roi
      %n_ppf=n_row*n_col;  % pixels per frame
      x_roi=zeros(n_frames,n_rois);

      % is this faster?  yes.  screw you, JIT compiler.
      for k=1:n_frames
        frame_this=self.get_frame(k);
        for l=1:n_rois
          roi_mask=roi_stack(:,:,l);
          s=sum(sum(roi_mask.*double(frame_this)));
          x_roi(k,l)=s/n_pels(l);
        end
      end

    end  % mean_over_rois()
    
    
  end  % methods

end  % classdef
