function choose_file_and_load(self)

% throw up the dialog box
[filename,pathname]= ...
  uigetfile({'*.tif','Multi-image TIFF files (*.tif)'; ...
             '*.mj2','Motion JPEG 2000 files (*.mj2)'}, ...
            'Load video from file...');
if isnumeric(filename) || isnumeric(pathname)
  % this happens if user hits Cancel
  return;
end

% load the optical data
file_name_full=fullfile(pathname,filename);
self.load_video_given_file_name(file_name_full);

end
