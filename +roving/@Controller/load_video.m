function load_video(self,data_raw,filename_local)

% make up a dt, t0
dt=0.050;  % s, => 20 Hz
t0=0;

% set the model
self.model=roving.Model(data_raw,dt,t0);

% set the view
self.view.new_model(self.model,filename_local);

% set self
self.card_birth_roi_next=1;

end
