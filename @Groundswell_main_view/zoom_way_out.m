function zoom_way_out(gsmv)

n_signals=gsmv.model.get_n_signals();
if n_signals>0
  tl=gsmv.model.get_tl();
  gsmv.set_tl_view(tl);
end
