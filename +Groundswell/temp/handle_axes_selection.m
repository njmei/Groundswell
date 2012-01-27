function handle_axes_selection(gsmc,y_axis_label_h)

% get the figure handle
groundswell_figure_h=gsmc.view.fig_h;

% get the handle of the single axes that was clicked on
axes_h=get(y_axis_label_h,'parent');

% normal click, shift click, control click?
selection_type=get(groundswell_figure_h,'selectiontype');

% get instance vars
i_selected=gsmc.view.i_selected;
axes_hs=gsmc.view.axes_hs;
selected=gsmc.view.get_selected_axes();

% get the index of the axes that was just clicked on
i=find(axes_hs==axes_h);

% change the selected set, and the order, as needed
switch selection_type
  case 'normal',
    % clicking without modifier key
    if selected(i)
      % if axes i is already selected
      n_selected=length(i_selected);
      if n_selected==1
        % if axes is the only one already selected, deselect it
        selected(i)=false;
        i_selected=zeros(1,0);
      else
        % if axes i is one of several selected axes, select only it
        selected=false(size(selected));
        selected(i)=true;
        i_selected=i;
      end
    else
      % if axes i is not already selected, select it
      selected=false(size(selected));
      selected(i)=true;
      i_selected=i;
    end      
  case 'extend',
    % on windows or GNOME, shift-clicking
    n_selected=length(i_selected);
    if n_selected==0
      % if nothing selected, select just i
      selected(i)=true;
      i_selected=i;
    else
      % if some axes are already selected
      i_selected_last=i_selected(end);
      if i<i_selected_last
        i_to_add=(i_selected_last:-1:i);
      else
        i_to_add=(i_selected_last:i);
      end
      selected(i_to_add)=true;
      i_to_add_new=setdiff_preserve_order(i_to_add,i_selected);
      i_selected=[i_selected i_to_add_new];
    end
  case 'alt',
    % on windows or GNOME, ctrl-clicking
    if selected(i)
      % if axes i is already selected, remove it
      selected(i)=false;
      i_selected(i_selected==i)=[];
    else
      % if axes i is not already selected, add it
      selected(i)=true;
      i_selected=[i_selected i];
    end
end

% update the view to reflect the change
gsmc.view.set_selected_axes(i_selected);

end  % function




function base=setdiff_preserve_order(base,delta)

% removes items in delta from base, preserving the order of base

n=length(delta);
eliminate=false(size(base));
for i=1:n
  eliminate=eliminate|(base==delta(i));
end
base(eliminate)=[];

end  % function

