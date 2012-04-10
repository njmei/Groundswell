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
      data_raw=load_ipl_file(file_name_full);      
    case '.mat'
      data_raw=load_anonymous(file_name_full);      
    otherwise
      error('unable to load that file type');
  end  
catch err
  self.unhourglass();
  if strcmp(err.identifier,'MATLAB:imagesci:imfinfo:whatFormat')
    errordlg(sprintf('Unable to determine file format of %s',filename),...
             'File Error');
    return;
  elseif strcmp(err.identifier,'MATLAB:load:notBinaryFile')
    errordlg(sprintf('%s does not seem to be a binary file.',filename),...
             'File Error');
    return;
  elseif strcmp(err.identifier,'TMT:load_anonymous:too_few_variables')
    errordlg(sprintf('No variables in %s.',filename),...
             'File Error');
    return;
  elseif strcmp(err.identifier,'TMT:load_anonymous:too_many_variables')
    errordlg(sprintf('Too many variables in %s.',filename),...
             'File Error');
    return;
  elseif isempty(err.identifier)
    errordlg(sprintf('Unable to read %s, and error lacks identifier.',filename),...
             'File Error');
    return;
  elseif strcmp(err.identifier,'TMT:load_ipl_file:header_error')
    errordlg(sprintf('Error reading header of %s.',filename),...
             'File Error');
    return;
  elseif strcmp(err.identifier,'TMT:load_ipl_file:frame_error')
    errordlg(sprintf('Error reading some frame of %s.',filename),...
             'File Error');
    return;
  else
    rethrow(err);
  end
end

% set the figure title
if isempty(filename)
  title_string='Roving';
else
  title_string=sprintf('Roving - %s',filename);
end
set(self.figure_h,'name',title_string);

% OK, now actually store the data in ourselves
self.load_video(data_raw);

end
