function choose_file_and_import(self)

% throw up the dialog box
[filename,pathname,i_filter]=...
  uigetfile({'*.abf' 'Axon binary format file (*.abf)';...
             '*.wav' 'Microsoft waveform audio file (*.wav)';
             '*.txt' 'Text file (*.txt)';
             '*.txt' 'Bayley-style text file, 5.0 um/pel (*.txt)';
             '*.txt' 'Bayley-style text file, 2.5 um/pel (*.txt)';
             '*.*'   'All files (*.*)'},...
            'Load data from file...');
if isnumeric(filename) || isnumeric(pathname)
  % this happens if user hits Cancel
  return;
end

% load the optical data
file_name_full=fullfile(pathname,filename);
self.import(file_name_full,i_filter);

end
