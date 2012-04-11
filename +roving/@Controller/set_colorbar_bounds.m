function set_colorbar_bounds(self,cb_min_string,cb_max_string)

% change the figure strings
self.colorbar_min_string=cb_min_string;
self.colorbar_max_string=cb_max_string;

% change the axes and colorbar
cb_min=str2double(cb_min_string);
cb_max=str2double(cb_max_string);
cb_increment=(cb_max-cb_min)/256;
set(self.colorbar_axes_h,'YLim',[cb_min cb_max]);
set(self.colorbar_h,'YData',[cb_min+0.5*cb_increment...
                             cb_max-0.5*cb_increment]);

% recalculate indexed_data, set in figure
if ~isempty(self.model)
  data=self.model.data;
  new_indexed_data=uint8(floor(255*(data-cb_min)/(cb_max-cb_min)));
  self.indexed_data=new_indexed_data;
  % change the displayed image
  frame_index=self.frame_index;
  this_frame=new_indexed_data(:,:,frame_index);
  set(self.image_h,'CData',this_frame);
end
