function handle_key(self)

%fprintf(1,'key\n');

% handle the key
key=get(self.figure_h,'CurrentCharacter');
switch key
  case { ',' , '<' }
    frame_index=self.frame_index;
    self.change_frame(frame_index-1);
  case { '.' , '>' }
    frame_index=self.frame_index;
    self.change_frame(frame_index+1);
  case 'p'
    roving.play(+1);
  case { char(8) , char(127) }  
    selected_roi_index=self.selected_roi_index;
    if ~isnan(selected_roi_index)
      self.delete_rois(selected_roi_index);
    end
end
