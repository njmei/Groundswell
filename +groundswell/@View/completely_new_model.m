function completely_new_model(self,model)

% Called when the model changes completely, as when a new data file is
% loaded.
%
% Causes the view to re-sync itself to the new model, re-drawing basically
% everything.

% Change self.model to point to the new model
self.model=model;

% set the view limits to the full time range
self.tl_view=self.model.tl;

% renew the axes
self.renew_axes();

% call resize() to draw the axes
self.resize();

% plot the traces with subsetting and subsampling
self.refresh_traces();

% enable controls as necessary
self.update_enablement_of_controls();
