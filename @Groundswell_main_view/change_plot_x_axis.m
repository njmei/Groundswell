function change_plot_x_axis(gsmv,new_plot_x_axis)

% get the figure handle
fig_h=gsmv.fig_h;

% get the current units
old_plot_x_axis=gsmv.plot_x_axis;

% set the instance var
gsmv.plot_x_axis=new_plot_x_axis;

% uncheck the old menu item
menu_h=findobj(fig_h,'Tag',sprintf('%s_menu_h',old_plot_x_axis));
set(menu_h,'Checked','off');

% check the new menu item
menu_h=findobj(fig_h,'Tag',sprintf('%s_menu_h',new_plot_x_axis));
set(menu_h,'Checked','on');

% update all axes, by treating this like a change of the time range in view
gsmv.set_tl_view(gsmv.tl_view);

% change the x-axis label, if there is one
axes_hs=gsmv.axes_hs;
if ~isempty(axes_hs)
  xlabel(axes_hs(end),get(menu_h,'label'));
end
