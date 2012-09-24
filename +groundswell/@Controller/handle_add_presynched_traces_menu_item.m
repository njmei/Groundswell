function handle_add_presynched_traces_menu_item(self)

% throw up the dialog box
[filename,pathname,i_filter]=...
  uigetfile({'*.abf' 'Axon binary format file (*.abf)';...
             '*.wav' 'Microsoft waveform audio file (*.wav)';
             '*.txt' 'Text file (*.txt)';
             '*.txt' 'Bayley-style text file, 5.0 um/pel (*.txt)';
             '*.txt' 'Bayley-style text file, 2.5 um/pel (*.txt)';
             '*.txt' 'Tracked muscles file (*.txt)';
             '*.*'   'All files (*.*)'},...
            'Load data from file...');
if isnumeric(filename) || isnumeric(pathname)
  % this happens if user hits Cancel
  return;
end

% Translate filter index to a file type string
if i_filter==4
  file_type_str='Bayley-style text, 5.0 um/pel';
elseif i_filter==5
  file_type_str='Bayley-style text, 2.5 um/pel';
elseif i_filter==5
  file_type_str='Tracked muscles text';
else
  file_type_str='';
end

% might take a while...
self.view.hourglass();

% load the data to be synched
full_filename=fullfile(pathname,filename);
[data_roi,t_roi,names_roi,units_roi]= ...
  groundswell.load_traces(full_filename,file_type_str);
if isempty(data_roi)
  self.view.unhourglass();
  return;
end

% Upsample the ROI data, trim the data data to put everything on a common
% time base.
[t,data]=...
  groundswell.upsample_to_common_3arg(self.model.t,self.model.data, ...
                                      data_roi);
                                    
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
