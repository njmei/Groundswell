function load_video_from_file(self,filename)

% filename is a filename, can be relative or absolute

% break up the file name
[~,base_name,ext]=fileparts(filename);
filename_local=[base_name ext];

% load the optical data
self.hourglass()
try
  switch ext
    case '.tif'
      data_raw=load_multi_image_tiff_file(filename);
    case '.ipl'
      data_raw=load_ipl_file(filename);      
    case '.mat'
      data_raw=load_anonymous(filename);      
    otherwise
      errordlg('Unable to load that file type','File Error');
      return
  end  
catch err
  self.unhourglass();
  if strcmp(err.identifier,'MATLAB:imagesci:imfinfo:whatFormat')
    errordlg(sprintf('Unable to determine file format of %s', ...
                     filename_local),...
             'File Error');
    return;
  elseif strcmp(err.identifier,'MATLAB:load:notBinaryFile')
    errordlg(sprintf('%s does not seem to be a binary file.', ...
                     filename_local),...
             'File Error');
    return;
  elseif strcmp(err.identifier,'TMT:load_anonymous:too_few_variables')
    errordlg(sprintf('No variables in %s.',filename_local),...
             'File Error');
    return;
  elseif strcmp(err.identifier,'TMT:load_anonymous:too_many_variables')
    errordlg(sprintf('Too many variables in %s.',filename_local),...
             'File Error');
    return;
  elseif isempty(err.identifier)
    errordlg(sprintf('Unable to read %s, and error lacks identifier.', ...
                     filename_local),...
             'File Error');
    return;
  elseif strcmp(err.identifier,'TMT:load_ipl_file:header_error')
    errordlg(sprintf('Error reading header of %s.',filename_local),...
             'File Error');
    return;
  elseif strcmp(err.identifier,'TMT:load_ipl_file:frame_error')
    errordlg(sprintf('Error reading some frame of %s.',filename_local),...
             'File Error');
    return;
  else
    rethrow(err);
  end
end

% set the figure title
if isempty(filename_local)
  title_string='Roving';
else
  title_string=sprintf('Roving - %s',filename_local);
end
set(self.figure_h,'name',title_string);

% OK, now actually store the data in ourselves
self.load_video(data_raw);

end
