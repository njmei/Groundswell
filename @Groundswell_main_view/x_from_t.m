function x=x_from_t(gsmv,t)

plot_x_axis=gsmv.plot_x_axis;
switch plot_x_axis
  case 'time_s',
    x=t;
  case 'time_ms',
    x=1000*t;
  case 'time_min',
    x=t/60;
  case 'time_hr',
    x=t/3600;
  otherwise,
    error('unknown plot_x_axis');
end
