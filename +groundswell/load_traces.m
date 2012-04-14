function [data,t,names,units]=load_traces(filename)

% parse the filename
[~,base_name,ext]=fileparts(filename);
filename_local=[base_name ext];

% fall-back return values
data=[];
t=[];
names=[];
units=[];

% load the data
if strcmp(ext,'.abf')
  try
    [t,data,names,units]=load_abf(filename);
  catch  %#ok
    %self.view.unhourglass();
    errordlg(sprintf('Unable to open file %s',filename_local));  
    return;
  end
elseif strcmp(ext,'.tcs')
  try
    [names,t_each,data_each,units]=read_tcs(filename);
  catch %#ok
    %self.view.unhourglass();
    errordlg(sprintf('Unable to open file %s',filename_local));  
    return;
  end
  % have to upsample data_each onto a common timeline, unless they're
  % already like that
  if ~groundswell.all_on_same_time_base(t_each)
    errordlg('All signals not on same time base.');
    return;
  end
  [data,t]=groundswell.common_from_each_trivial(t_each,data_each);
  clear t_each data_each;
elseif strcmp(ext,'.wav')
  try
    [data,fs]=wavread(filename);
  catch %#ok
    %self.view.unhourglass();
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
    data=load(filename);
  catch exception  %#ok
    %self.view.unhourglass();
    errordlg(sprintf('Unable to open file %s',filename_local));  
    return;
  end
  [n_t,n_chan]=size(data);
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
else
  errordlg('Don''t know how to open a file with that extension');
  return;
end

% get rid of leading, trailing spaces in names, units
names=strtrim(names);
units=strtrim(units);

end