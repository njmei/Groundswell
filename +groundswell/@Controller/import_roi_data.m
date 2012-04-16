function import_roi_data(self)

% throw up the dialog box
[filename,pathname]=...
  uigetfile({'*.tcs' 'Traces file (*.tcs)'; ...
             '*.abf' 'Axon binary format file (*.abf)';...
             '*.wav' 'Microsoft waveform audio file (*.wav)';
             '*.txt' 'Text file (*.txt)';
             '*.*'   'All files (*.*)'},...
            'Load data from file...');
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

% need to massage the exposure times, since there may be extra pulses
n_frame=length(t_roi);
n_exposure=length(t_exposure);
if n_exposure==n_frame+1
  t_exposure=t_exposure(1:end-1);
elseif n_exposure==n_frame+2
  t_exposure=t_exposure(2:end-1);
elseif n_exposure==n_frame
  % all good, do nothing
else
  errordlg(...
    sprintf('There are %d frames, but %d exposure pulses.  Aborting.', ...
            n_frame,n_exposure));
  return;
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
