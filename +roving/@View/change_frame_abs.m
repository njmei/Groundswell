function change_frame_abs(self,new_frame_index)

% get state variables
indexed_data=self.indexed_data;
n_frames=size(indexed_data,3);
image_h = self.image_h;
frame_index_edit_h=self.frame_index_edit_h;
% change things to accord with the new frame index
if (new_frame_index>=1) && (new_frame_index<=n_frames)
  self.frame_index=new_frame_index;
  set(frame_index_edit_h,'String',sprintf('%d',new_frame_index));
  this_frame = indexed_data(:,:,new_frame_index);
  set(image_h,'CData',this_frame);
end

end
