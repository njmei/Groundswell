function load_video_given_file_object(self,file,filename_local)

% make up a t0, get dt
t0=0;
dt=file.dt;  % s

% set the model
self.model=roving.Model(file,dt,t0);

% set the view
self.view.new_model(self.model,filename_local);

% set self
self.card_birth_roi_next=1;

end
