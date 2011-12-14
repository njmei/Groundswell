function zoom_in(gsmv)

n_signals=gsmv.model.get_n_signals();
if n_signals>0
  tl_view=gsmv.tl_view;
  tw=tl_view(2)-tl_view(1);
  tl_view_new=tl_view(1)+[0 tw/2];
  gsmv.set_tl_view(tl_view_new);
end
