function load_data(self)

% get the figure handle
groundswell_figure_h=self.view.fig_h;

% throw up the dialog box
[filename,pathname]=...
  uigetfile({'*.abf' 'Axon binary format file (*.abf)';...
             '*.tcs' 'Traces file (*.tcs)';
             '*.wav' 'Microsoft waveform audio file (*.wav)';
             '*.txt' 'Text file (*.txt)';
             '*.*'   'All files (*.*)'},...
            'Load data from file...');
if isnumeric(filename) || isnumeric(pathname)
  % this happens if user hits Cancel
  return;
end

% might take a while...
set(groundswell_figure_h,'pointer','watch');
drawnow('update');
drawnow('expose');

% load the data
len=length(filename);
if strcmp(filename(len-3:len),'.abf')
  full_filename=fullfile(pathname,filename);
  try
    [t,data,names,units]=load_abf(full_filename);
  catch exception
    set(groundswell_figure_h,'pointer','arrow');
    drawnow('update');
    drawnow('expose');
    errordlg(sprintf('Unable to open file %s',filename));  
    return;
  end
elseif strcmp(filename(len-3:len),'.tcs')
  full_filename=fullfile(pathname,filename);
  try
    [names,t_each,data_each,units]=read_tcs(full_filename);
  catch exception
    set(groundswell_figure_h,'pointer','arrow');
    errordlg(sprintf('Unable to open file %s',filename));  
    return;
  end
  % have to upsample data_each onto a common timeline, unless they're
  % already like that
  if ~Groundswell_main_controller.all_on_same_time_base(t_each)
    button=questdlg(['All signals not on same time base.  ' ...
                     'Limit time range and upsample slow signals?'],...
                    'Limit time range and upsample?',...
                    'Upsample','Cancel',...
                    'Upsample');
    if strcmp(button,'Cancel')
      set(groundswell_figure_h,'pointer','arrow');
      return;
    end
  end
  [t,data]=...
    Groundswell_main_controller.upsample_to_common(t_each,data_each);
elseif strcmp(filename(len-3:len),'.wav')
  full_filename=fullfile(pathname,filename);
  try
    [data,fs]=wavread(full_filename);
  catch exception
    set(groundswell_figure_h,'pointer','arrow');
    drawnow('update');
    drawnow('expose');
    errordlg(sprintf('Unable to open file %s',filename));  
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
    units{i}=sprintf('V',i);
      % it's surprisingly hard to find out how to convert, say, a 16-bit
      % audio sample (as on a CD) to a line-level voltage.  But I think
      % this is correct.  I.e. -2^15 = -32768 => -1 V
  end
elseif strcmp(filename(len-3:len),'.txt')
  full_filename=fullfile(pathname,filename);
  try
    data=load(full_filename);
  catch exception
    set(groundswell_figure_h,'pointer','arrow');
    drawnow('update');
    drawnow('expose');
    errordlg(sprintf('Unable to open file %s',filename));  
    return;
  end
  % We assume the data is sampled at 1 kHz, for lack of a better
  % assumption.
  dt=0.001;  % s
  [n_t,n_chan]=size(data);
  t=dt*(0:(n_t-1))';  % s
  names=cell(n_chan,1);
  for i=1:n_chan
    names{i}=sprintf('x%d',i);
  end
  units=cell(n_chan,1);
  for i=1:n_chan
    units{i}=sprintf('?',i);
  end
else
  errordlg('Don''t know how to open a file with that extension');
  return;
end

% get rid of leading, trailing spaces in names, units
names=strtrim(names);
units=strtrim(units);

% store all the data-related stuff in the model
self.model.set_t_data_names_units(t,data,names,units);

% make the view reflect the modified model
self.view.renew(self.model);

% ok, we're done
set(groundswell_figure_h,'pointer','arrow');
drawnow('update');
drawnow('expose');
