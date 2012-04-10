function choose_file_and_load(self)

% throw up the dialog box
[filename,pathname]= ...
  uigetfile({'*.tif','Multi-image TIFF files (*.tif)'; ...
             '*.ipl','Photometrics format (*.ipl)'; ...
             '*.mat','Matlab .mat with single variable in it (*.mat)'}, ...
            'Load video from file...');
if isnumeric(filename) || isnumeric(pathname)
  % this happens if user hits Cancel
  return;
end

% load the optical data
file_name_full=fullfile(pathname,filename);
self.load_video_from_file(file_name_full);

end
