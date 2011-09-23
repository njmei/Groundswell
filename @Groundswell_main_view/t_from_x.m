function t=t_from_x(gsmv,x)

plot_x_axis=gsmv.plot_x_axis;
switch plot_x_axis
  case 'time_s',
    t=x;
  case 'time_ms',
    t=x/1000;
  case 'time_min',
    t=x*60;
  case 'time_hr',
    t=x*3600;
  otherwise,
    error('unknown plot_x_axis');
end
