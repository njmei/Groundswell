function step_left(gsmv)

n_signals=gsmv.model.get_n_signals();
if n_signals>0
  tl=gsmv.model.get_tl();
  tl_view=gsmv.tl_view;
  tw=tl_view(2)-tl_view(1);
  t0=tl(1);
  tl_view_new=tl_view-0.05*tw;
  if tl_view_new(1)<t0
    tl_view_new=[t0 t0+tw];
  end
  gsmv.set_tl_view(tl_view_new);
end
