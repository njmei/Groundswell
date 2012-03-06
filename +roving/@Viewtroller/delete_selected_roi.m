function delete_selected_roi(self)

% Get the indices of the selected ROIs
i=self.selected_roi_index;
if ~isempty(i)
  self.delete_rois(i);
end

end
