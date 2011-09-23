function str=time_units_string(gsmv)

plot_x_axis=gsmv.plot_x_axis;
switch plot_x_axis
  case 'time_s',
    str='s';
  case 'time_ms',
    str='ms';
  case 'time_min',
    str='min';
  case 'time_hr',
    str='hr';
  otherwise,
    error('unknown plot_x_axis');
end

