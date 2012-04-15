function import(self,filename,i_filter)

% filename is a filename, can be relative or absolute
% i_filter, if present, is the index of the filter chosen in the
% file finder dialog.  This is used to determine if we're dealing with
% "Bayley-style" text files.

% deal with args
if nargin<2
  i_filter=[];
end

% Constants.
i_bayley_25=5;  % index of Bayley-style file at 2.5 um/pel

% Get the absolute filename
if strcmp(filename(1),filesep)
  filename_abs=filename;
else
  filename_abs=fullfile(pwd(),filename);
end
clear filename

% break up the file name
[~,base_name,ext]=fileparts(filename_abs);
filename_local=[base_name ext];

% might take a while...
self.view.hourglass();

% load the data
if strcmp(ext,'.abf')
  try
    [t,data,names,units]=load_abf(filename_abs);
  catch  %#ok
    self.view.unhourglass();
    errordlg(sprintf('Unable to open file %s',filename_local));  
    return;
  end
elseif strcmp(ext,'.wav')
  try
    [data,fs]=wavread(filename_abs);
  catch %#ok
    self.view.unhourglass();
    errordlg(sprintf('Unable to open file %s',filename_local));  
    return;
  end
  dt=(1/fs);
  [n_t,n_chan]=size(data);
  t=dt*(0:(n_t-1))';  % s
  names=cell(n_chan,1);
  for i=1:n_chan
    names{i}=sprintf('x%d',i);
  end
  units=cell(n_chan,1);
  for i=1:n_chan
    units{i}='V';
      % it's surprisingly hard to find out how to convert, say, a 16-bit
      % audio sample (as on a CD) to a line-level voltage.  But I think
      % this is correct.  I.e. -2^15 = -32768 => -1 V
  end
elseif strcmp(ext,'.txt')
  try
    is_bayley_style_p= ...
      groundswell.is_bayley_style(filename_abs);
    if is_bayley_style_p
      if i_filter==i_bayley_25        
        [t,data,names,units]= ...
          groundswell.load_txt_bayley(filename_abs,2.5);
      else
        [t,data,names,units]= ...
          groundswell.load_txt_bayley(filename_abs,5.0);
      end        
    else
      data=load(filename_abs);
    end
  catch exception  %#ok
    self.view.unhourglass();
    errordlg(sprintf('Unable to open file %s',filename_local));  
    return;
  end
  [n_t,n_chan]=size(data);
  if ~is_bayley_style_p
    % For plain=old text files, we assume the data is sampled at 1 kHz, for
    % lack of a better assumption.
    dt=0.001;  % s
    t=dt*(0:(n_t-1))';  % s
    names=cell(n_chan,1);
    for i=1:n_chan
      names{i}=sprintf('x%d',i);
    end
    units=cell(n_chan,1);
    for i=1:n_chan
      units{i}='?';
    end
  end
else
  errordlg('Don''t know how to open a file with that extension');
  return;
end

% get rid of leading, trailing spaces in names, units
names=strtrim(names);
units=strtrim(units);

% store all the data-related stuff in a newly-created model
file_native=false;  % because it's an import
self.model=groundswell.Model(t,data,names,units, ...
                             filename_abs,file_native);

% set fs_str
fs=(length(t)-1)/(t(end)-t(1));  % Hz
self.fs_str=sprintf('%0.16g',fs);

% make the view reflect the modified model
self.view.completely_new_model(self.model);

% ok, we're done
self.view.unhourglass();

end
