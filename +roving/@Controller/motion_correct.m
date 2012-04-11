function motion_correct(self)

data=self.model.data;
border=2;  % border to ignore, seems to help with nans and such at the
           % edge of the frames
self.view.hourglass();
data_corrected=subtract_translation(data,border);
self.model.data=data_corrected;
self.view.model_data_changed();
self.view.unhourglass();

end
