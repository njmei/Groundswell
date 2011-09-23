function set_selected_axes(gsmv,...
                           i_selected_new)

% get the figure handle
groundswell_figure_h=gsmv.fig_h;

% get stuff from the figure                                   
axes_hs=gsmv.axes_hs;
i_selected_old=gsmv.i_selected;
%selected_old=gsmv.get_selected_axes();

% which have axes have changed their selection state?
i_changed=setxor(i_selected_old,i_selected_new);

% cycle through changed axes and update the display
for i=i_changed
  y_label_h=get(axes_hs(i),'ylabel');  % handle of text object
  if any(i==i_selected_new)
    set(y_label_h,'fontweight','bold');
  else
    set(y_label_h,'fontweight','normal');
  end
end

% change the last selected, new and old
if ~isempty(i_selected_old)
  i_selected_last_old=i_selected_old(end);
  y_label_h=get(axes_hs(i_selected_last_old),'ylabel');  % handle of text object
  set(y_label_h,'fontangle','normal');
end
if ~isempty(i_selected_new)
  i_selected_last_new=i_selected_new(end);
  y_label_h=get(axes_hs(i_selected_last_new),'ylabel');  % handle of text object
  set(y_label_h,'fontangle','italic');
end

% update the display
drawnow;  

% store stuff in the figure
gsmv.i_selected=i_selected_new;

% enable/disable controls
gsmv.update_enablement_of_controls();
