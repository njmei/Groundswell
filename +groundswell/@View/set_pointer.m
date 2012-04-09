function set_pointer(self,pointer_string)

set(self.fig_h,'pointer',pointer_string);
drawnow('update');
drawnow('expose');
