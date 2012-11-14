function logify_y_ticks(limits_y)

% This assumes that the y values plotted are s.t. y=log10(z), and that the
% y-axis ticks should be adjusted to show values of z, not y, in the usual
% way that a log-axis is done.  Why not just use the built-in capabilities
% of a Matlab axes object to do this?  Because you might actually be
% plotting a spectrogram with the freqeuency axis logged, and Matlab
% doesn't support this natively.  Also, for instance, patch object don't
% seem to work with a log axis.  plot_h is the handle of the Matlab axes
% object for which you want the y axis "logified".

limits_y=get(plot_h,'ylim');  % the limits of the y axis (in log units)
[tick_z,is_major_tick,is_minor_tick]= ...
  log_ticks_from_limits(limits_y);
n_ticks=length(tick_z);
if n_ticks>=2
  % this is the usual case, when the axis limits span a good-sized
  % range of values
  tick_y=log10(tick_z);
  set(plot_h,'ytick',tick_y,'yticklabel',tick_z);
else
  % if the y axis has a smallish range, the usual way of doing log-scale
  % ticks may lead to one or zero tick marks.  In this case, we just modify
  % the labels of the current ticks
  
end


end
