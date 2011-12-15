function coherency_at_f_probe(self)

% get the figure handle
groundswell_figure_h=self.view.fig_h;

% get stuff we'll need
i_selected=self.view.i_selected;
t=self.model.t;
data=self.model.data;
names=self.model.names;

% are there exactly two signals selected?
n_selected=length(i_selected);
if n_selected~=2
  errordlg('Can only calculate coherency between two signals at a time.',...
           'Error');
  return;
end

% get indices of signals
i_y=i_selected(1);  % the non-pivot is the output/test signal
i_x=i_selected(2);  % the pivot is the input/reference signal

% extract the data we need
n_t=length(t);
n_sweeps=size(data,3);
x=reshape(data(:,i_x,:),[n_t n_sweeps]);
name_x=names{i_x};  %#ok
%units_x=units{i_x};
y=reshape(data(:,i_y,:),[n_t n_sweeps]);
name_y=names{i_y};
%units_y=units{i_y};
clear data;

% calc sampling rate
dt=(t(end)-t(1))/(length(t)-1);
f_samp=1/dt;
f_nyquist=0.5*f_samp;

% throw up the dialog box
param_str=inputdlg({ 'Number of windows:' , ...
                     'Time-bandwidth product (NW):' , ...
                     'Number of tapers:' , ...
                     'Probe frequency (Hz):' ,...
                     'Extra FFT powers of 2:' , ...
                     'Confidence level:' , ...
                     'Alpha of threshold:' },...
                     'Coherency parameters...',...
                   1,...
                   { '1' , ...
                     '4' , ...
                     '7' , ...
                     sprintf('%0.3f',f_nyquist/2) , ...
                     '2' , ...
                     '0.95' ,...
                     '0.05' },...
                   'off');
if isempty(param_str)
  return;
end

% break out the returned cell array
n_windows_str=param_str{1};
NW_str=param_str{2};
K_str=param_str{3};
f_probe_str=param_str{4};
p_FFT_extra_str=param_str{5};
conf_level_str=param_str{6};
alpha_thresh_str=param_str{7};

%
% convert strings to numbers, and do sanity checks
%

% n_windows
n_windows=str2double(n_windows_str);
if isempty(n_windows)
  errordlg('Number of windows not valid','Error');
  return;
end
if n_windows~=round(n_windows)
  errordlg('Number of windows must be an integer','Error');
  return;
end
if n_windows<1
  errordlg('Number of windows must be >= 1','Error');
  return;
end

% NW
NW=str2double(NW_str);
if isempty(NW)
  errordlg('Time-bandwidth product (NW) not valid','Error');
  return;
end
if NW<1
  errordlg('Time-bandwidth product (NW) must be >= 1','Error');
  return;
end

% K
K=str2double(K_str);
if isempty(K)
  errordlg('Number of tapers not valid','Error');
  return;
end
if K~=round(K)
  errordlg('Number of tapers must be an integer','Error');
  return;
end
if K>2*NW-1
  errordlg('Number of tapers must be <= 2*NW-1','Error');
  return;
end

% f_probe
f_probe=str2double(f_probe_str);
if isempty(f_probe)
  errordlg('Probe frequency not valid','Error');
  return;
end
if f_probe<0
  errordlg('Probe frequency must be >= 0','Error');
  return;
end
if f_probe>f_nyquist
  errordlg(sprintf(['Probe frequency must be <= half the ' ...
                    'sampling frequency (%0.3f Hz)'],f_samp),...
           'Error');
  return;
end

% p_FFT_extra
p_FFT_extra=str2double(p_FFT_extra_str);
if isempty(p_FFT_extra)
  errordlg('Extra FFT powers of 2 not valid','Error');
  return;
end
if p_FFT_extra~=round(p_FFT_extra)
  errordlg('Extra FFT powers of 2 must be an integer','Error');
  return;
end
if p_FFT_extra<0
  errordlg('Extra FFT powers of 2 must be >= 0','Error');
  return;
end

% conf_level
conf_level=str2double(conf_level_str);
if isempty(conf_level)
  errordlg('Confidence level not valid','Error');
  return;
end
if conf_level<0
  errordlg('Confidence level must be >= 0','Error');
  return;
end
if conf_level>=1
  errordlg('Confidence level must be < 1',...
           'Error');
  return;
end

% alpha_thresh
alpha_thresh=str2double(alpha_thresh_str);
if isempty(alpha_thresh)
  errordlg('Alpha of threshold not valid','Error');
  return;
end
if alpha_thresh<0
  errordlg('Alpha of threshold must be >= 0','Error');
  return;
end
if alpha_thresh>1
  errordlg('Alpha of threshold must be <= 1',...
           'Error');
  return;
end

%
% all parameters are converted, and are in-bounds
%



%
% do the analysis
%

% may take a while
set(groundswell_figure_h,'pointer','watch');
drawnow('update');
drawnow('expose');

% % to test
% data(:,1)=cos(2*pi*1*t);

% get just the data in view
tl=self.model.get_tl();
tl_view=self.view.tl_view;
N=self.model.get_n_t();
jl=interp1(tl,[1 N],tl_view,'linear','extrap');
jl(1)=floor(jl(1));
jl(2)= ceil(jl(2));
jl(1)=max(1,jl(1));
jl(2)=min(N,jl(2));
x_short=x(jl(1):jl(2),:);
y_short=y(jl(1):jl(2),:);
clear t x y;
N=size(x_short,1);

% center the data
x_short_mean=mean(x_short,1);
x_short_cent=x_short-repmat(x_short_mean,[N 1]);
y_short_mean=mean(y_short,1);
y_short_cent=y_short-repmat(y_short_mean,[N 1]);

% determine window size
N_window=floor(N/n_windows);
%T_window=dt*N_window;

% want N to be integer multiple of N_window
N=N_window*n_windows;
x_short_cent=x_short_cent(1:N,:);
y_short_cent=y_short_cent(1:N,:);
%T=dt*N;

% put windows into the second index
x_short_cent_windowed=...
  reshape(x_short_cent,[N_window n_windows*n_sweeps]);
y_short_cent_windowed=...
  reshape(y_short_cent,[N_window n_windows*n_sweeps]);

% figure out the highest frequency we'll need to get f_probe
N_fft=2^(ceil(log2(N_window))+p_FFT_extra);
df=f_samp/N_fft;
F_keep=df*(ceil(f_probe/df)+1);  % +1 just to be sure...

% calc the coherency, using multitaper routine
[f,Cyx_mag,Cyx_phase,...
 N_fft,f_res_diam,~,...
 Cyx_mag_ci,Cyx_phase_ci]=...
  coh_mt(dt,y_short_cent_windowed,x_short_cent_windowed,...
         NW,K,F_keep,...
         p_FFT_extra,conf_level);  %#ok
%n_f=length(f);

% calc the significance threshold, quick
R=n_windows*n_sweeps;  % number of samples of each process
%alpha_thresh=0.05;
Cyx_mag_thresh=coh_mt_control_analytical(R,K,alpha_thresh);

% interpolate to get C at the probe freq
Cyx_mag_probe=interp1(f,Cyx_mag,f_probe,'*linear');
Cyx_phase_probe=interp1(f,Cyx_phase,f_probe,'*linear');
Cyx_mag_ci_probe=interp1(f,Cyx_mag_ci,f_probe,'*linear');
Cyx_phase_ci_probe=interp1(f,Cyx_phase_ci,f_probe,'*linear');

% plot coherency at the probe f
% title_str=sprintf('Coherency of %s relative to %s, at f=%f Hz',...
%                   name_y,name_x,f_probe);
figure_coh_polar(Cyx_mag_probe,Cyx_phase_probe,...
                 Cyx_mag_ci_probe,Cyx_phase_ci_probe,...
                 1,{name_y},...
                 0,Cyx_mag_thresh,...
                 1,...
                 'l75_border_of_r_theta',[0 0 0]);    
h_fig_coh=gcf;
%set(h_fig_coh,'name',fig_border_label);
set(h_fig_coh,'color','w');
drawnow('update');
drawnow('expose');

% set pointer back
set(groundswell_figure_h,'pointer','arrow');
drawnow('update');
drawnow('expose');
