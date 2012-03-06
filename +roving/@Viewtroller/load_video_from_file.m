function load_video_from_file(self)

% throw up the dialog box
[filename,pathname]=uigetfile('*.tif','Load video from file...');
if isnumeric(filename) || isnumeric(pathname)
  % this happens if user hits Cancel
  return;
end

% load the optical data
file_name_full=fullfile(pathname,filename);
set(self.figure_h,'pointer','watch');
drawnow('update');  drawnow('expose');
try
  data_raw=load_multi_image_tiff_file(file_name_full);
catch  %#ok
  set(self.figure_h,'pointer','arrow');
  drawnow('update');  drawnow('expose');
  errordlg(sprintf('Unable to open file %s',filename),...
           'File Error');
  return;
end

% OK, now actually store the data in ourselves
self.load_video(data_raw);

end
