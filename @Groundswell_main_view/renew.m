function renew(gsmv)

% set the view limits to the full time range
gsmv.tl_view=gsmv.model.get_tl();

% renew the axes
gsmv.renew_axes();

% call resize() to draw the axes
gsmv.resize();

% plot the traces with subsetting and subsampling
gsmv.refresh_traces();

% enable controls as necessary
gsmv.update_enablement_of_controls();
