function to_start(gsmv)

n_signals=gsmv.model.get_n_signals();
if n_signals>0
  tl=gsmv.model.get_tl();
  tl_view=gsmv.tl_view();
  tw=tl_view(2)-tl_view(1);
  t0=tl(1);
  gsmv.set_tl_view([t0 t0+tw]);
end
