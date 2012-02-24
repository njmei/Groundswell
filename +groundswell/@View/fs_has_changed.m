function fs_has_changed(self,model)

% set the view limits to the full time range
self.tl_view=model.tl;

% % get the number of channels
% self.n_chan=model.n_chan;

% % renew the axes
% self.renew_axes(model);

% % call resize() to draw the axes
% self.resize();

% plot the traces with subsetting and subsampling
self.refresh_traces(model);

% % enable controls as necessary
% self.update_enablement_of_controls();
