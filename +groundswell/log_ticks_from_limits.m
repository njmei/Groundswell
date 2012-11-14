function [tick_z,is_major_tick,is_minor_tick]= ...
  log_ticks_from_limits(limits_y)

% This assumes that the y values plotted are s.t. y=log10(z), and that the
% y-axis ticks should be adjusted to show values of z, not y, in the usual
% way that a log-axis is done.  Why not just use the built-in capabilities
% of a Matlab axes object to do this?  Because you might actually be
% plotting a spectrogram with the freqeuency axis logged, and Matlab
% doesn't support this natively.  Also, for instance, patch object don't
% seem to work with a log axis.  plot_h is the handle of the Matlab axes
% object for which you want the y axis "logified".

%limits_y=get(plot_h,'ylim');  % the limits of the y axis (in log units)
limits_y
limits_z=10.^limits_y  % the limits of the y axis in native units
limits_exponent=floor(limits_y)  % the exponent (base 10) of the two limits
limits_mantissa=limits_z./(10.^limits_exponent)  % the mantissa of the two limits
extremal_ticks_exponent=limits_exponent;
extremal_ticks_mantissa=[ceil(limits_mantissa(1)) floor(limits_mantissa(2))]
if extremal_ticks_mantissa(1)==10
  extremal_ticks_exponent(1)=extremal_ticks_exponent(1)+1;
  extremal_ticks_mantissa(1)=0;
end
% shouldn't there be some similar check on the upper extremum

% generate all the tick points
tick_exponent=zeros(0,1);
tick_mantissa=zeros(0,1);
tick_exponent_unique=(limits_exponent(1):limits_exponent(2))';
n_orders_of_magnitude=length(tick_exponent_unique)
for i=1:n_orders_of_magnitude
  tick_exponent_unique_this=tick_exponent_unique(i)
  if i==1 && i==n_orders_of_magnitude
    z_mult_tick_this=(extremal_ticks_mantissa(1):extremal_ticks_mantissa(2))';    
  elseif i==1
    z_mult_tick_this=(extremal_ticks_mantissa(1):9)';    
  elseif i==n_orders_of_magnitude
    z_mult_tick_this=(1:extremal_ticks_mantissa(2))';    
  else
    z_mult_tick_this=(1:9)';
  end
  y_floor_tick_this=repmat(tick_exponent_unique_this, ...
                           size(z_mult_tick_this));
  tick_mantissa=[tick_mantissa;z_mult_tick_this];
  tick_exponent=[tick_exponent;y_floor_tick_this];
end
tick_exponent
tick_mantissa
tick_z=(10.^tick_exponent).*tick_mantissa
tick_y=log10(tick_z)
%is_major_tick=(tick_mantissa==1)
%is_minor_tick=~is_major_tick

end
