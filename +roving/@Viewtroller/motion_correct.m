function motion_correct(self)

data=self.model.data;
border=2;  % border to ignore, seems to help with nans and such at the
           % edge of the frames
self.hourglass();
data_corrected=subtract_translation(data,border);
self.load_video(data_corrected);
self.unhourglass();

end
