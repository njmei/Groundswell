function load_video_from_file(self)

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
set(self.figure_h,'pointer','watch');
drawnow('update');  drawnow('expose');
try
  [dummy,dummy,ext]=fileparts(filename);  %#ok
  switch ext
    case '.tif'
      data_raw=load_multi_image_tiff_file(file_name_full);
    case '.ipl'
      data_raw=roving.load_ipl_file(file_name_full);      
    case '.mat'
      data_raw=load_anonymous(file_name_full);      
    otherwise
      error('unable to load that file type');
  end  
catch  %#ok
  set(self.figure_h,'pointer','arrow');
  drawnow('update');  drawnow('expose');
  errordlg(sprintf('Unable to open file %s',filename),...
           'File Error');
  return;
end

% set the figure title
if isempty(filename)
  title_string='roving';
else
  title_string=sprintf('Roving - %s',filename);
end
set(self.figure_h,'name',title_string);

% OK, now actually store the data in ourselves
self.load_video(data_raw);

end
