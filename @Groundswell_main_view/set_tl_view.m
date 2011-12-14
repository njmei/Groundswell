function set_tl_view(self,tl_view_new_want,model)

% save the new tl
self.tl_view=tl_view_new_want;

% refresh the traces on-screen to reflect the changed self.tl_view
self.refresh_traces(model);
