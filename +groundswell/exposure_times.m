function [t_frame,T_frame,dt_frame_start,dt_frame_end,...
          i_rising,i_falling] = ...
  exposure_times(t,exposure_bool)

% the boolean exposure signal tells when the CCD is being exposed
% we assume t, exposure are column vectors

n_samples=length(t);
edge=ttl_edges(exposure_bool);
if exposure_bool(1)
  %warning('groundswell:exposure_starts_high', ...
  %        'exposure starts high!');
  % eliminate first falling edge
  i_edge=find(edge==(-1));
  edge(i_edge(1))=0;
end
if exposure_bool(end)
  %warning('groundswell:exposure_ends_high', ...
  %        'exposure ends high!');
  % eliminate last rising edge
  i_edge=find(edge==(+1));
  edge(i_edge(end))=0;  
end
% The ith rising edge marks the start of the ith frame
i_rising=find(edge==(+1));
i_falling=find(edge==(-1));
% i_rising and i_falling should be the same length
t_frame_start=(t(i_rising)+t(i_rising+1))/2;
t_frame_end=(t(i_falling)+t(i_falling+1))/2;
t_frame=(t_frame_start+t_frame_end)/2;
T_frame=t_frame_end-t_frame_start;  % frame duration
dt_frame_start=t_frame_start-t_frame;
dt_frame_end=t_frame_end-t_frame;

end
