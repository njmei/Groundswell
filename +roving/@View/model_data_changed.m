function model_data_changed(self)

% The data in the model (but not the dimensions of the data, nor the time
% information) has changed.  Need to update self appropriately.

% sync up the indexed data
cb_min=str2double(self.colorbar_min_string);
cb_max=str2double(self.colorbar_max_string);
self.indexed_data=uint8(round(255*(self.model.data-cb_min)/...
                                  (cb_max-cb_min)));

% extract the current frame
this_frame=self.indexed_data(:,:,self.frame_index);

% change the image data in the image HG object
set(self.image_h,'cdata',this_frame);

% update the figure
drawnow('update');
drawnow('expose');

end
