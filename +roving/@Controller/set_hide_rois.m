function set_hide_rois(self,hide_rois_new)

label_h=self.label_roi_h;
border_h=self.border_roi_h;
if hide_rois_new
  % hide them
  for j=1:length(label_h)
    set(label_h(j),'Visible','off');
    set(border_h(j),'Visible','off');
  end
  self.hide_rois=true;
  set(self.hide_rois_menu_h,'Label','Show ROIs');
  set(self.rename_roi_menu_h,'enable','off');
  set(self.delete_roi_menu_h,'enable','off');
  % set the image erase mode
  set(self.image_h,'EraseMode','none');
else
  % show them
  for j=1:length(label_h)
    set(label_h(j),'Visible','on');
    set(border_h(j),'Visible','on');
  end
  self.hide_rois=false;
  set(self.hide_rois_menu_h,'Label','Hide ROIs');
  n_roi=length(self.model.roi);
  if n_roi>0
    set(self.rename_roi_menu_h,'enable','on');
    set(self.delete_roi_menu_h,'enable','on');
  end
  % set the image erase mode
  set(self.image_h,'EraseMode','normal');
end
