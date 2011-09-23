function set_tl_view(gsmv,tl_view_new_want)

% get the figure handle
groundswell_figure_h=gsmv.fig_h;

% if tl_view_new_want is empty, do nothing
if isempty(tl_view_new_want)
  return;
end

% make sure right order
tl_view_new_want_srt=sort(tl_view_new_want); 

% limit to data bounds
tl=gsmv.model.get_tl();
t0=tl(1);
tf=tl(2);
tl_view_new_want_srt_constrained(1)=...
  min(max(tl_view_new_want_srt(1),t0),tf);
tl_view_new_want_srt_constrained(2)=...
  min(max(tl_view_new_want_srt(2),t0),tf);

% make sure the bounds are still valid
if tl_view_new_want_srt_constrained(1)==tl_view_new_want_srt_constrained(2)
  return;
end

% if we get here, tl_view_new_want_srt_constrained is valid

% save the new tl
gsmv.tl_view=tl_view_new_want_srt_constrained;

% refresh the traces on-screen to reflect the changed gsmv.tl_view
gsmv.refresh_traces();
