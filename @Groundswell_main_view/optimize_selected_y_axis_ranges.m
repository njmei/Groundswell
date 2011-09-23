function optimize_selected_y_axis_ranges(gsmv)

% get stuff we'll need
axes_hs=gsmv.axes_hs;
i_selected=gsmv.i_selected;
t=gsmv.model.t;
data=gsmv.model.data;

% do it
n_t=length(t);
tl_view=gsmv.tl_view;
jl=interp1([t(1) t(end)],[1 n_t],tl_view,'linear','extrap');
jl(1)=floor(jl(1));
jl(2)= ceil(jl(2));
jl(1)=max(1,jl(1));
jl(2)=min(n_t,jl(2));
for i=i_selected
  y_min=min(min(data(jl(1):jl(2),i,:)));  
  y_max=max(max(data(jl(1):jl(2),i,:)));
  y_mid=(y_min+y_max)/2;  y_radius=(y_max-y_min)/2;
  if y_radius==0
    y_radius=1;
  end
  y_lo=y_mid-1.1*y_radius;  y_hi=y_mid+1.1*y_radius;
  set(axes_hs(i),'YLim',[y_lo y_hi]);
end
