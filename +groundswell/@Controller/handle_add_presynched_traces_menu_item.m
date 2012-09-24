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
elseif i_filter==6
  file_type_str='Tracked muscles text';
else
  file_type_str='';
end

% might take a while...
self.view.hourglass();

% load the data to be synched
full_filename=fullfile(pathname,filename);
[data_new,~,names_new,units_new]= ...
  groundswell.load_traces(full_filename,file_type_str);
if isempty(data_new)
  self.view.unhourglass();
  return;
end

% Upsample the new data to put everything on a common
% time base.
data=...
  groundswell.resample_to_common(self.model.t,self.model.data, ...
                                 data_new);
                                    
% merge names, units
names=vertcat(self.model.names,names_new);
units=vertcat(self.model.units,units_new);

% store all the data-related stuff in a newly-created model
saved=false;
self.model=groundswell.Model(self.model.t,data,names,units, ...
                             self.model.filename_abs, ...
                             self.model.file_native, ...
                             saved);

% make the view reflect the modified model
self.view.completely_new_model(self.model);

% ok, we're done
self.view.unhourglass();

end
