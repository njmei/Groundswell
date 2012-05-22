function import_roi_data(self,import_mode_str)

% deal with args
if nargin<2
  import_mode_str='';
end
ft_mode=strcmpi(import_mode_str,'FT');
  % true if optical data was acquired in frame-transfer mode
normal_mode=~ft_mode;

% throw up the dialog box
[filename,pathname]=...
  uigetfile({'*.tcs' 'Traces file (*.tcs)'; ...
             '*.abf' 'Axon binary format file (*.abf)';...
             '*.wav' 'Microsoft waveform audio file (*.wav)';
             '*.txt' 'Text file (*.txt)';
             '*.*'   'All files (*.*)'},...
            'Load ROI traces from file...');
if isnumeric(filename) || isnumeric(pathname)
  % this happens if user hits Cancel
  return;
end

% might take a while...
self.view.hourglass();

% load the data to be synched
full_filename=fullfile(pathname,filename);
[data_roi,t_roi,names_roi,units_roi]= ...
  groundswell.load_traces(full_filename);
if isempty(data_roi)
  self.view.unhourglass();
  return;
end

% get the selected signal
i_selected=self.view.i_selected;
exposure=self.model.data(:,i_selected);
exposure_mid=(min(exposure)+max(exposure))/2;
exposure=(exposure>exposure_mid);  % boolean

% determine timeline for the exposures
t_exposure= ...
  groundswell.exposure_times(self.model.t,exposure);

% need to massage the exposure times, since there may be extra pulses, or
% not enough pulses.
n_frame=length(t_roi);
n_exposure=length(t_exposure);
if normal_mode
  if n_exposure>n_frame
    % if the roi data is not in frame transfer more, throw up a warning if
    % there are two more pulses than frames, since that's the usual signature
    % of frame transfer data
    if n_exposure==n_frame+2
      button_label= ...
        questdlg(...
          sprintf(['There are %d frames, and %d exposure pulses.  ' ...
                   'Data acquired in frame-transfer mode typically has ' ...
                   'two more pulses than frames.  Are you sure you want ' ...
                   'to proceed, treating this as non-frame-transfer data?'], ...
                  n_frame,n_exposure), ...
          'Really non-frame-transfer?', ...
          'Proceed','Cancel', ...
          'Cancel');
      if ~strcmp(button_label,'Proceed')
        self.view.unhourglass();
        return;
      end
    end
    % ignore exposure pulses at end
    t_exposure=t_exposure(1:n_frame);
  elseif n_exposure<n_frame
    errordlg(...
      sprintf(['There are %d frames, but only %d exposure pulses.  ' ...
               'Aborting.'], ...
              n_frame,n_exposure));
    self.view.unhourglass();
    return;
  end
  % If n_expsoure==n_frame, nothing to do.  (Although, this case actually
  % seems to be somewhat unusual, since in normal mode there's usually n+1
  % exposure pulses, where n is the number of frames, and the last pulse is
  % shorter than the rest, and doesn't correspond to a frame.)
else
  % optical data was acquired in frame-transfer mode
  
  % frame-transfer mode should always have an initial exposure pulse
  % that does not correspond to a frame.  If there are extra pulses, even
  % taking the above into account, they are assumed to come _after_ the
  % frames.

  if n_exposure>n_frame+1
    % ignore first pulse, and any extra pulses at end
    t_exposure=t_exposure(2:n_frame+1);
  elseif n_exposure<n_frame+1
    % not enough exposure pulses
    if n_exposure==n_frame
      % A special case that requires some explaining.
      errordlg(...
        sprintf(['There are %d frames, and %d exposure pulses, ' ...
                 'but the first pulse is ignored for ' ...
                 'frame-transfer data, so there are not enough ' ...
                 'exposure pulses.  Aborting.'], ...
                n_frame,n_exposure));
    else
      % The usual case, given that n_exposure<n_frame+1
      errordlg(...
        sprintf(['There are %d frames, but only %d exposure pulses.  ' ...
                 '(And the first pulse is ignored for ' ...
                 'frame-transfer data.)  ' ...
                 'Aborting.'], ...
                n_frame,n_exposure+1));
      % n_exposure is one less than the true number of of exposure pulses.        
    end    
    self.view.unhourglass();
    return;
  else  % i.e. if n_exposure==n_frame+1
    % While not necessarily a problem, this is the usual signature of data 
    % acquired in non-frame-transfer mode.  Double-check with the user.
    button_label= ...
      questdlg(...
        sprintf(['There are %d frames, and %d exposure pulses.  ' ...
                 'Data acquired in non-frame-transfer mode typically has ' ...
                 'one more pulse than frames.  Are you sure you want ' ...
                 'to proceed, treating this as frame-transfer data?'], ...
                n_frame,n_exposure), ...
        'Really frame-transfer?', ...
        'Proceed','Cancel', ...
        'Cancel');
    if ~strcmp(button_label,'Proceed')
      self.view.unhourglass();
      return;
    end
    % if user is sure, ignore first exposure pulse
    t_exposure=t_exposure(2:end);  
  end
end

% Upsample the ROI data, trim the data data to put everything on a common
% time base.
[t,data]=...
  groundswell.upsample_to_common_4arg(self.model.t,self.model.data, ...
                                      t_exposure,data_roi);
                                    
% merge names, units
names=vertcat(self.model.names,names_roi);
units=vertcat(self.model.units,units_roi);

% store all the data-related stuff in a newly-created model
saved=false;
self.model=groundswell.Model(t,data,names,units, ...
                             self.model.filename_abs, ...
                             self.model.file_native, ...
                             saved);

% set fs_str
fs=(length(t)-1)/(t(end)-t(1));  % Hz
self.fs_str=sprintf('%0.16g',fs);

% make the view reflect the modified model
self.view.completely_new_model(self.model);

% ok, we're done
self.view.unhourglass();

end
