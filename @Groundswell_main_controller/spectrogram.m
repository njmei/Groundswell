function spectrogram(gsmc)

% get the figure handle
groundswell_figure_h=gsmc.view.fig_h;

% get stuff we'll need
selected=gsmc.view.get_selected_axes();
t=gsmc.model.t;
data=gsmc.model.data;
names=gsmc.model.names;
units=gsmc.model.units;
n_sweeps=size(data,3);
tl_view=gsmc.view.tl_view;

% check number of signals selected
n_selected=sum(selected);
if n_selected~=1
  errordlg('Can only calculate spectrogram on one signal at a time.',...
           'Error');
  return;
end

% check number of sweeps
if isempty(n_sweeps) || n_sweeps~=1
  errordlg('Must have exactly one sweep to calculate spectrogram.',...
           'Error');
  return;
end

% get data we care about
data=data(:,selected);
name=names{selected};
units=units{selected};

% calc sampling rate
N=length(t);
dt=(t(end)-t(1))/(N-1);
%f_samp=1/dt;
%f_nyquist=0.5*f_samp;
%T=N*dt;

% throw up the dialog box, check params
params=Groundswell_main_controller.get_spectrogram_params(tl_view,dt);

% check for error exit
if isempty(params)
  return;
end

% break out params
T_window_want=params.T_window_want;
n_steps_per_window_want=params.n_steps_per_window_want;
NW=params.NW;
K=params.K;
F_keep=params.F_keep;
p_FFT_extra=params.p_FFT_extra;


%
% do the analysis
%

% may take a while
set(groundswell_figure_h,'pointer','watch'); drawnow;

% % to test
% data(:,1)=cos(2*pi*1*t);

% get just the data in view
jl=interp1([t(1) t(end)],[1 N],tl_view,'linear','extrap');
jl(1)=floor(jl(1));
jl(2)= ceil(jl(2));
jl(1)=max(1,jl(1));
jl(2)=min(N,jl(2));
t_short=t(jl(1):jl(2));
data_short=data(jl(1):jl(2));
clear t data;
N=length(data_short);
dt=(t_short(end)-t_short(1))/(N-1);

% center the data
data_short_mean=mean(data_short,1);
data_short_cent=data_short-data_short_mean;

% determine desired window step size
dt_window_want=T_window_want/n_steps_per_window_want;

% check T_window_want, dt_window want before calling powgram_mt
% this part relies on knowing how powgram_mt determines
% N_window and di_window given T_window_want, dt_window_want, and dt
% not a very elegant way of doing things, but the alternative was an
% extended orgy of refactoring (but like a bad orgy)
N_window=round(T_window_want/dt);  % number of samples per window
di_window=round(dt_window_want/dt);
if N_window<=1
  set(groundswell_figure_h,'pointer','arrow'); drawnow;
  errordlg(['The requested window duration (and the sampling rate of ' ...
            'the data) will result in one or fewer spectrogram windows.'],...
           'Error');
  return;
end
if di_window<1
  set(groundswell_figure_h,'pointer','arrow'); drawnow;
  errordlg(['The requested window duration and number of steps per ' ...
            'window (and the sampling rate of ' ...
            'the data) will result in a step size of less than one ' ...
            'sample between spectrogram windows.'],...
           'Error');
  return;
end
if ~(2*NW<N_window)
  set(groundswell_figure_h,'pointer','arrow'); drawnow;
  errordlg(['The requested window duration (and the sampling rate of ' ...
            'the data) results in a window size less than or equal to ' ...
            '2*NW.'],...
           'Error');
  return;
end 

% calc spectrogram
[f,t,~,P]=...
  powgram_mt(dt,data_short_cent,...
             T_window_want,dt_window_want,...
             NW,K,F_keep,...
             p_FFT_extra);

% plot spectrogram
title_str=sprintf('Spectrogram of %s',name);
h=figure_powgram(t,f,P,...
                 tl_view,[0 F_keep],[],...
                 'power',[],...
                 title_str,...
                 units);
set(h,'name',title_str);

% set pointer back
set(groundswell_figure_h,'pointer','arrow'); drawnow;
