function delete_all_rois(self)

n_rois=length(self.model.roi);
roi_list=(1:n_rois)';
self.delete_rois(roi_list);

end
