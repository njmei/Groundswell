function zoom_way_out(self)

n_chan=self.model.get_n_chan();
if n_chan>0
  tl=self.model.get_tl();
  self.set_tl_view(tl);
end
