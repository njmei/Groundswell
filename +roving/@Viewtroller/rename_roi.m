function rename_roi(self)

% Get the selected ROI.
roi_index=self.selected_roi_index;
if isempty(roi_index)
  return;
end

% get some handles we'll need
%label_h=[self.roi_struct.label_h]';
this_label_h=self.label_roi_h(roi_index);

% get the current label string
this_label_string=get(this_label_h,'String');

% throw up the dialog box
new_label_string=...
  inputdlg({ 'New ROI name:' },...
           'Rename ROI...',...
           1,...
           { this_label_string },...
           'off');
if isempty(new_label_string) 
  return; 
end

% break out the returned cell array                
new_label_string=new_label_string{1};

% if new value is not taken, change label
if ~self.label_in_use(new_label_string)
  set(this_label_h,'String',new_label_string);
  self.model.roi(roi_index).label=new_label_string;
  % these lines are necessary to prevent the unselected boxes from 
  % disappearing.  I don't know why they disappear, but there you go.
  set(self.image_h,'Selected','on');
  set(self.image_h,'Selected','off');  
end

end
