function set_colorbar_bounds(self,cb_min_string,cb_max_string)

% change the figure strings
self.colorbar_min_string=cb_min_string;
self.colorbar_max_string=cb_max_string;

% change the axes and colorbar
cb_min=str2double(cb_min_string);
cb_max=str2double(cb_max_string);
set(self.colorbar_axes_h,'YLim',[cb_min cb_max]);
% cb_increment=(cb_max-cb_min)/256;
% set(self.colorbar_h,'YData',[cb_min+0.5*cb_increment...
%                              cb_max-0.5*cb_increment]);
set(self.colorbar_h,'YData',[cb_min cb_max]);

% store the tracslated vals in self
self.colorbar_min=cb_min;
self.colorbar_max=cb_max;

% recalculate indexed_frame, set in figure
if ~isempty(self.model)
  % change the displayed image
  set(self.image_h,'CData',self.indexed_frame);
end

end
