function play_as_audio(self)

% get the figure handle
groundswell_figure_h=self.view.fig_h;

% get stuff we'll need
selected=self.view.get_selected_axes();
data=self.model.data;

% get the selected signal
n_signals=sum(selected);
if n_signals==0
  return;
elseif n_signals>1
  errordlg('Can only play one signal as audio at a time.',...
           'Error');
  return;
end
data=data(:,selected);

% get just the data in view
t=self.model.t;
tl_view=self.view.tl_view;
N=length(t);
jl=interp1([t(1) t(end)],[1 N],tl_view,'linear','extrap');
clear t;
jl(1)=floor(jl(1));
jl(2)= ceil(jl(2));
jl(1)=max(1,jl(1));
jl(2)=min(N,jl(2));
data=data(jl(1):jl(2));
N=length(data);

% get sampling rate
fs=self.model.fs;  % hz

% if a long sample, make sure user wants to do this
dt=1/fs;
T=N*dt;
T_warn=10;  % s
if T>T_warn
  question_string=...
    sprintf(['This signal is %0.0f seconds long, and playback ' ...
             'cannot be stopped.  Play anyway?'], ...
            T);
  button=questdlg(question_string, ...
                  'Really play?', ...
                  'Play','Cancel', ...
                  'Play');
  if isempty(button) || strcmp(button,'Cancel')
    return;
  end
end

% Short sounds sometimes don't get played, so pad out to 1 s.
% This may be a general issue with audioplayer, or might be a linux 
% oddity.
T_pad=1;  % s
if T<T_pad
  N_pad=round(T_pad*fs);
  data(N_pad)=0;
end

% may take a while
T_warn=1;  % s
if T>T_warn
  set(groundswell_figure_h,'pointer','watch');
  drawnow('update');
  drawnow('expose');
end

% scale the data
data_max=max(abs(data));
if data_max>0
  data=0.99*data/data_max;
end

% play the sound, scaled
player=audioplayer(data,fs);
tic
player.playblocking();
toc

% % block while sound plays
% while player.isplaying()
%   disp('pause');
%   pause(0.050);
% end

% set pointer back
if T>T_warn
  set(groundswell_figure_h,'pointer','arrow');
  drawnow('update');
  drawnow('expose');
end

end
